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

type env = (markup, language);

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
    ('b', "begin", "set the markup begin line"),
    ('e', "end", "set the markup end line"),
    ('c', "comment", "set the language comment symbol"),
    ('m', "tex|md", "use preset markup language"),
    ('l', "c|python", "use preset programming language"),
    "<input>");
  defer getopt::finish(&cmd);

  if (len(cmd.args) != 1) {
    getopt::printusage(os::stderr, os::args[0], cmd.help)!;
    os::exit(1);
  };

  let env = (latex, c);
  for (const opt .. cmd.opts) {
    switch (opt.0) {
      case 'b' => env.0.begin = opt.1;
      case 'e' => env.0.end = opt.1;
      case 'c' => env.1.comment = opt.1;
      case 'm' =>
        switch (opt.1) {
          case "tex" => env.0 = latex;
          case "md" => env.0 = markdown;
          case => fmt::fatal("error: unsupported markup language '{}'", opt.1);
        };
      case 'l' =>
        switch (opt.1) {
          case "c" => env.1 = c;
          case "python" => env.1 = python;
          case => fmt::fatal("error: unsupported programming language '{}'", opt.1);
        };
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
        if (line == env.0.end) {
          fmt::println(env.1.comment, line)!;
          code_mode = false;
        } else {
          fmt::println(line)!;
        };
      } else {
        fmt::println(env.1.comment, line)!;
        if (line == env.0.begin) {
          code_mode = true;
        };
      };
  };
};
