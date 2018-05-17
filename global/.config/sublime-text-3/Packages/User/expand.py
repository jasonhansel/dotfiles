#!/usr/bin/env python3
try:
    import sublime
    import sublime_plugin
except ImportError:
    pass
import re
import unittest
import itertools
import collections

brackets = {
    '' : '',
    '(' : ')',
    '{' : '}',
    '﹝' : '﹞'
}
inv_brackets = {
    v : k
    for k, v in brackets.items()
}


def parse(text):
    level = ''
    ret = []
    thus_far = ''
    first = True
    den = ''
    for char in text:
        to_append = char
        if level == '':
            if (char == '(' or char == '﹝'):
                if len(thus_far.strip()): ret.append([('', 'N', thus_far.strip())])
                ret.append([])
                thus_far = ''
                to_append = ''
        if level == '(' or level == '﹝':
            if char == '／' and den[-1] == 'N':
                # )
                ret[-1].append((level[-1], 'N', thus_far.strip()))
                den = den[:-1] + 'D'
                thus_far = ''
                # ( 
                # 1 /
                to_append = ''
            if (char == '+' or char == '-' or char == brackets[level]) and den[-1] == 'N':
                if len(thus_far.strip()): ret[-1].append((level[-1], 'N', thus_far.strip()))
                thus_far = ''
                if char == brackets[level]:
                    to_append = ''
            if (char == brackets[level]) and den[-1] == 'D':
                ret.append([(level[-1], 'D', thus_far.strip())])
                thus_far = ''
                to_append = ''

        if char in brackets:
            level += char
            den += 'N'
        elif char in inv_brackets and inv_brackets[char] == level[-1]:
            level = level[:-1]
            den = den[:-1]

        thus_far += to_append
        first = False

    if len(thus_far.strip()): ret.append([(level, 'N', thus_far.strip())])
    thus_far = ''
    return ret




def expand(text):
    # pb = parse_bracketed(text)
    # if pb is not None:
    #     nums, den = pb
    #     return '\n'.join([(nsign + ' {' + ndata + den) for (nsign, ndata) in nums])

    combos = list(itertools.product(*parse(text)))
    ret = collections.OrderedDict()
    
    for combo in combos:
        out = ''
        mul = 1
        denom = []
        for (bracket, nd, part) in combo:
            if nd == 'D':
                denom.append((bracket, part.strip()))
            elif nd == 'N':
                if part[0] == '+':
                    mul *= 1
                    part = part[1:]
                elif part[0] == '-':
                    mul *= -1
                    part = part[1:]
                part = part.strip()
                if part.isdigit():
                    mul *= int(part)
                    part = ''
                if len(part):
                    out += bracket +  part.strip() + brackets[bracket]
        if len(denom) == 0:
            denom = ''
        elif len(denom) == 1:
            bracket, text = denom[0]
            denom = text
        else:
            denom = ''.join([ bracket + text + brackets[bracket] for (bracket, text) in denom])

        if len(denom):
            if out == '':
                out = '1'
            out = '{' + out + '／' + denom + '}'

        if out in ret:
            ret[out.strip()] += mul
        else:
            ret[out.strip()] = mul
    fin = []
    for out, mul in ret.items():
        if mul != 0:
            if mul >= 0: sign = '+'
            else: sign = '-'
            sign += ' ';
            if abs(mul) != 1 or out == '': sign += "{0}".format(abs(mul))
            fin.append(sign + out)
    return '\n'.join(fin)


class TestStringMethods(unittest.TestCase):
    def test_expand(self):
        self.assertEqual(
            expand("22(50)"),
            "+ 1100"
        )
        self.assertEqual(
            expand("22(x + y(a + b) - z)4"),
            "+ 88(x)\n+ 88(y(a + b))\n- 88(z)"
        )
        self.assertEqual(
            expand("(x - 5)22(x + y(a+b) - z)"),
            "+ 22(x)(x)\n+ 22(x)(y(a+b))\n- 22(x)(z)\n- 110(x)\n- 110(y(a+b))\n+ 110(z)"
        )
        self.assertEqual(
            expand("(x - 5)(x - 5)"),
            "+ (x)(x)\n- 10(x)\n+ 25"
        )
        self.assertEqual(
            expand("z(x - 5)(x - 5)"),
            "+ z(x)(x)\n- 10z(x)\n+ 25z"
        )
        self.assertEqual(
            expand("z﹝x - 5﹞(x - 5)"),
            "+ z﹝x﹞(x)\n- 5z﹝x﹞\n- 5z(x)\n+ 25z"
        )
    def test_div(self):
        self.assertEqual(
            expand("(x5 - {x10／2}(z + 1) ／ 3)"),
            "+ {(x5)／3}\n- {({x10／2}(z + 1))／3}"
        )
        self.assertEqual(
            expand("{x}\sin{x5 - x10(z + 1) ／ 3}"),
            "+ {x}\sin{x5 - x10(z + 1) ／ 3}"
        )
        self.assertEqual(
            expand("﹝x5 - x10 ／ 3﹞"),
            "+ {﹝x5﹞／3}\n- {﹝x10﹞／3}"
        )
        self.assertEqual(
            expand("{x5 - x10 ／ 3}(x + 1)"),
            "+ {x5 - x10 ／ 3}(x)\n+ {x5 - x10 ／ 3}"
        )
    def test_divb(self):
        self.assertEqual(
            expand("{x5 - x10 ／ 3}﹝x + 1﹞"),
            "+ {x5 - x10 ／ 3}﹝x﹞\n+ {x5 - x10 ／ 3}"
        )
        self.assertEqual(
            expand("﹝x5 - x10 ／3﹞﹝x + 1﹞"),
            "+ {﹝x5﹞﹝x﹞／3}\n+ {﹝x5﹞／3}\n- {﹝x10﹞﹝x﹞／3}\n- {﹝x10﹞／3}"
        )
        self.assertEqual(
            expand("﹝{x10 ／3}﹞﹝x + 1﹞"),
            "+ ﹝{x10 ／3}﹞﹝x﹞\n+ ﹝{x10 ／3}﹞"
        )
        self.assertEqual(
            expand("﹝x ／3﹞﹝x ／3﹞"),
            "+ {﹝x﹞﹝x﹞／﹝3﹞﹝3﹞}"
        )
        self.assertEqual(
            expand("{x + 1 ／ 2}﹝x + 1 ／ 2﹞"),
            "+ {{x + 1 ／ 2}﹝x﹞／2}\n+ {{x + 1 ／ 2}／2}"
        )
    def test_fix(self):
        self.assertEqual(
            expand("x^{(5-3)}"),
            "+ x^{(5-3)}"
        )
        self.assertEqual(
            expand("﹝x + 1／2﹞"),
            "+ {﹝x﹞／2}\n+ {1／2}"
        )
        self.assertEqual(
            expand("﹝x + 1﹞"),
            "+ ﹝x﹞\n+ 1"
        )


if __name__ == '__main__':
    unittest.main()


class JasonExpand(sublime_plugin.TextCommand):
    def run(self, edit):
        selection = self.view.sel()
        if len(selection) == 1:
            text = self.view.substr(selection[0])
            print(text)
            self.view.replace(edit, selection[0], expand(self.view.substr(selection[0])))
        print(self.view)
        # self.view.insert(edit, 0, "Hello, World!")

class JasonVars(sublime_plugin.TextCommand):
    def run(self, edit):
        selection = self.view.sel()
        numbers = []
        def repl(match):
            greek = match.group(0)
            if greek not in numbers:
                numbers.append(greek)
            return "${" + str(numbers.index(greek) + 1) + ":" + greek + "}"

        if len(selection) == 1:
            text = self.view.substr(selection[0])
            self.view.run_command("insert_snippet", {"contents": re.sub('[Α-ω]', repl, text) } )
