from SublimeLinter.lint import Linter  # or NodeLinter, PythonLinter, ComposerLinter, RubyLinter


class __class__(Linter):
    cmd = '/home/work/bin/splchk'
    multiline = False
    defaults = {
        'selector': 'text.tex.latex'
    }
    regex = r'^(?P<line>\d+) (?P<col>\d+) (?P<message>.*)$'
