# Parsing For Humans

A presentation about the basics of parsing data using Ragel, Racc and Ruby.

## Sections

* Introduction about me (keep it short)
* What is parsing?
* Terminology
  * Token
  * AST
  * Lexer
  * Parser
* List various tools (Ragel, Yacc, Bison, Racc, StringScanner, etc)
* Lexing data using Ragel
* Creating an AST using Racc
* Real word example: Oga
  * Discuss the lexer
  * Discuss the parser
* Q&A

## Introduction About Me

Hi, I'm Yorick. I work at a little company called Olery in Amsterdam Zuid.
Part of what we do involves scraping, lots of it. We use Ruby for pretty much
everything, perhaps a bit too much. We're hiring.

## What Is Parsing

Parsing is the process of taking raw input, usually some form of text, and
turning it into a more meaningful sequence of data. For example, take the
string "10 + 10". In it's raw form this is just a string, you can't really do
much with it. However, when we parse it we can indicate that "10" is a number,
that "+" is an operator and so forth. In other words, we add meaning and
context to the input.

## Terminology

The parsing world is riddled with fancy terms that, if you don't know what they
mean, make things more complicated than needed. I won't be discussing all of
them, since there are too many, but here are the most important ones:

* Token
* AST
* Lexer
* Parser

### Token

A token can be seen as a label for a specific part of the input. For example,
in the Ruby program `10 + 10` we have 3 tokens:

* An integer
* An operator
* Another integer

Often tokens are stored as simple Arrays, though this is by no means a standard
or requirement. An example set of tokens for the above program looks like the
following:

    [ [:INTEGER, 10], [:OPERATOR, '+'], [:INTEGER, 10] ]

### AST

An AST is a tree structure that can be traversed and often queried. Take for
example the following Ruby program:

    10 + 10

If we were to parse this using the "parser" Gem we'd get the following AST:

    (send (int 10) :+ (int 10))

In a way an AST can be seen as a tolk. It translates the raw input into
something the target system can understand.

### Lexer

A lexer is a system that takes raw input, usually text, and returns a set of
tokens based on that input. Lexers are not always required depending on the
type of parser used (some parsers lex input for you).

### Parser

A parser is a system that, usually, takes a set of input tokens returned from a
lexer and returns an AST. Some parsers don't need a separate lexer as they will
handle this themselves. In this talk I'll focus on parser systems that *do*
require a separate lexer.

## Tools

There are many tools out there you can use to parse data. This is just a small
list:

* ANTLR
* Bison
* Coco/R
* Flex
* Happy
* Lemon
* Parslet
* Racc
* Ragel
* Rexical
* Treetop
* Yacc
* jQuery

For this talk I'll only focus on the following two:

* Ragel
* Racc

## Ragel

Ragel is in its own words "a state machine compiler". This is quite the fancy
term but what it comes down to is that it's a lexer capable of keeping track of
state for you.

As the name might hint at, Ragel *generates* lexers. It supports generating
lexers in the following languages: C, C++, C#, D, Go, Objective-C,
Objective-C++, Ruby, Java and OCaml.

Ragel uses regular expressions for matching input and running corresponding
actions. For example, if we want to match an XML comment we could write the
following pattern:

    xml_comment = '<!--' any* '-->';

Here `any*` indicates an optional sequence of any character. This results in
both `<!-- foo -->` and `<!---->` being matched.

Just creating patterns is a bit boring, we can add actions to run as following:

    xml_comment => {
      # do something with the current comment
    };

Ragel has a wide variety of different action types (in terms of when they are
executed) but we'll stick with the most basic one shown above for the sake of
simplicity.

## Racc

Racc is a tool that can be used to turn a sequence of tokens into an AST.
Similar to Ragel Racc generates a standalone parser written in Ruby.
