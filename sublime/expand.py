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


def parse(text):
    level = ''
    ret = []
    thus_far = ''
    for char in text:
        to_append = char
        if level == '':
            if char == '(':
                if len(thus_far.strip()): ret.append([thus_far.strip()])
                thus_far = ''
                ret.append([])
                to_append = ''
        if level == '(':
            if (char == '+' or char == '-' or char == ')'):
                if len(thus_far.strip()):  ret[-1].append(thus_far.strip())
                thus_far = ''
            if char == ')':
                to_append = ''
        if char == '(': level += '(';
        elif char == ')' and level[-1] == '(': level = level[:-1]
        if char == '{': level += '{';
        elif char == '}' and level[-1] == '{': level = level[:-1]
        thus_far += to_append
    if len(thus_far.strip()): ret.append([thus_far.strip()])
    thus_far = ''
    return ret

def expand(text):
    combos = list(itertools.product(*parse(text)))
    ret = collections.OrderedDict()
    for combo in combos:
        out = ''
        mul = 1
        for part in combo:
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
                out += '(' + part.strip() + ')'  
        if out in ret:
            ret[out] += mul
        else:
            ret[out] = mul
    fin = []
    for out, mul in ret.items():
        if mul != 0:
            if mul >= 0: sign = '+'
            else: sign = '-'
            sign += ' ';
            if abs(mul) != 1: sign += "{0}".format(abs(mul))
            fin.append(sign + out)
    return '\n'.join(fin)


class TestStringMethods(unittest.TestCase):
    def test_parse(self):
        self.assertEqual(
            parse("22(50)"),
            [["22"], ["50"]]
        )
        self.assertEqual(
            parse("22(x + y(a + b) - z)4"),
            [["22"], ["x", "+ y(a + b)", "- z"], ["4"]]
        )
        self.assertEqual(
            parse("(x - 5)22(x + y(a + b) - z)4"),
            [["x", "- 5"], ["22"], ["x", "+ y(a + b)", "- z"], ["4"]]
        )
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
    def test_fix(self):
        self.assertEqual(
            expand("x^{(5-3)}"),
            "+ (x^{(5-3)})"
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
