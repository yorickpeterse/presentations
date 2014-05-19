# Parsing For Humans

## Title

Kick off the amazingly well prepared presentation. Hopefully people enjoy the
font choice.

## About me

Hi, I'm Yorick. You can find me pretty much everywhere using this handle. From
Github to Twitter and from Gmail to the secret NSA database.

## Olery

We aggregate review data mainly for the hospitality industry. This involves
scraping websites, ingesting APIs and everything in between. We use Ruby for
all of this. To give some numbers, we scrape around 50.000 profile pages
(consisting out of multiple review pages) from around 65 different sources
(websites and APIs).

## We're Hiring

Tell the audience that we're hiring and that they should grab me if they'd like
to know more.

## Parsing

Wikipedia defines the term parsing as "Analysing a string of symbols according
to the rules of a grammar". What this means is that you have a set of rules for
your input. These rules they specify what the input should look like, what
order it should appear in and what to do with it.

## 10 + 10

For example, you might be writing a basic calculator that should process the
expression `10 + 10`. Now your parser would specify that it can handle integers
and operators (such as the addition operator or plus sign). It would also
specify the order of these elements so that it can handle invalid input one way
or another.

## Grammar example

To give a very basic example in pseudo code, to parse the expression `10 + 10`
we could use this grammar.

## Vocabulary

The parsing business is riddled with fancy terms. To clear things up I'll be
explaining the following terms:

* Token
* AST
* Lexer/tokenizer
* Parser

## Token

A token is a "label" for a specific part of the input. Tokens are used to
describe what certain parts of the input are.

## Token: 10

For example, for a calculator the number "10" would have the token
`[:INTEGER, '10']`. In this example I've used a Ruby Array as the data
structure.

## Abstract Syntax Tree

An Abstract Syntax Tree, or AST for short, is a tree data structure that
represents the input. It's often the final result in the parsing process. A
tree structure is often used to allow for nested data. It's worth mentioning
that ASTs are not always needed and/or used. This depends on the complexity of
the input.

## AST: Lists

As an example, take a list created in Markdown.

## AST Example

The corresponding AST would look something like the following. Note that the
used formatting here is just a way to visualize it.

## Lexer

A lexer is a system that takes raw input, often a string, and returns a
sequence of tokens as the output.

## Parser

A parser is a system that, usually, takes a sequence of tokens as input and
returns an AST as the output. Some parsers don't require a separate lexer and
instead operate directly on the raw input.

## Tools

With the boring terms out of the way, lets take a look at some actual tools.
There are many programs out there for parsing data.

## Tools List

These are just some of the hundreds of available programs for parsing data.
None of these names are made up by the way.

## Ragel & Racc

For this talk I'll only be discussing two programs: Ragel and Racc.

## Ragel

Ragel is, in its own words, a "finite state machine compiler". In layman's
terms, it's a program that generates a standalone lexer in a given language.
Ragel currently supports languages such as C, C++, C#, D, Ruby, Java, OCaml and
a bunch of others.

When using Ragel you define a set of patterns to match and a set of
corresponding actions to execute. These actions can use whatever language you
are targeting. For example, if you want to have a Ruby lexer then you can just
use Ruby code here.

## Ragel Example

As an example, this is how you would define a pattern to match XML comments in
Ragel. The code in curly braces would be executed whenever the pattern would
match. In this block you'd have access to information such as the current
string, start/stop position and so forth.

## Racc

Racc is a LALR(1) parser generator. LALR stands for Look-Ahead LR Parser. A
LALR parser processes input from left to right and from the bottom to the top.

Racc is written as a Ruby C extension (or a JRuby extension in case of JRuby)
and generates a standalone parser for you. By default it *does* require Racc to
be installed during runtime but you can optionally disable that requirement.

Unlike Ragel Racc does not operate on raw input directly, instead it operates
on tokens. As such your grammar does not contain patterns of text, but instead
patterns of tokens.

## Racc Example

For example, if we want to parse the expression `10 + 10` and assuming we have
the corresponding tokens returned from a lexer, then we can write our Racc
grammar as following.

## Quick Recap

So a quick recap. We have a lexer, which takes raw input and returns tokens,
and we have a parser that takes tokens and returns an AST.

## Oga

Discuss Oga, why I wrote it, etc. Show the lexer/parser.

## Questions?
