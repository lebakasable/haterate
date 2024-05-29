use fmt;
use os;
use io;
use bufio;
use getopt;

type markup = struct {
  begin: str,
  end: str,
};

type language = struct {
  comment: str,
};

let latex = markup {
  begin = "\\begin{code}",
  end = "\\end{code}",
};

let markdown = markup {
  begin = "```python",
  end = "```",
};

let c = language {
  comment = "//",
};

let python = language {
  comment = "#",
};

export fn main() void = {
  const cmd = getopt::parse(os::args,
    "haterate",
    ('m', "tex|md", "use preset markup language"),
    ('l', "c|python", "use preset programming language"),
    ('b', "begin", "override the markup begin line"),
    ('e', "end", "override the markup end line"),
    ('c', "comment", "override the language comment symbol"),
    ('o', "file", "override the output file (stdout by default)"),
    "<input>");
  defer getopt::finish(&cmd);

  if (len(cmd.args) != 1) {
    getopt::printusage(os::stderr, os::args[0], cmd.help)!;
    os::exit(1);
  };

  let markup = latex;
  let language = c;
  let output = os::stdout;
  defer io::close(output)!;
  for (const opt .. cmd.opts) {
    switch (opt.0) {
      case 'm' =>
        switch (opt.1) {
          case "tex" => markup = latex;
          case "md" => markup = markdown;
          case => fmt::fatal("error: unsupported markup language '{}'", opt.1);
        };
      case 'l' =>
        switch (opt.1) {
          case "c" => language = c;
          case "python" => language = python;
          case => fmt::fatal("error: unsupported programming language '{}'", opt.1);
        };
      case 'b' => markup.begin = opt.1;
      case 'e' => markup.end = opt.1;
      case 'c' => language.comment = opt.1;
      case 'o' => output = os::create(opt.1, 429)!;
      case => abort();
    };
  };

  let input = os::open(cmd.args[0])!;
  defer io::close(input)!;

  let scanner = bufio::newscanner(input);
  defer bufio::finish(&scanner);

  let code_mode = false;

  for (true) match (bufio::scan_line(&scanner)!) {
    case io::EOF => break;
    case let line: const str =>
      if (code_mode) {
        if (line == markup.end) {
          fmt::fprintln(output, language.comment, line)!;
          code_mode = false;
        } else {
          fmt::fprintln(output, line)!;
        };
      } else {
        fmt::fprintln(output, language.comment, line)!;
        if (line == markup.begin) {
          code_mode = true;
        };
      };
  };
};
