# ASON

_ANON_ (stands for _XiaoXuan Script Object Notation_) is a data format that is easy for humans to read and write. It is similar to _JSON_, but has many improvements and enhancements.

_ANON_ is mainly used as a configuration file for applications, but can also be used for data transmission.

**Features**

- **Compatible with most of the syntax of _JSON_ and _JSON5_.** If you are already familiar with _JSON_, you do not need to learn a new data format.

- **Simple, rigorous and consistent syntax.** The syntax of _ASON_ is close to that of programming languages. For example, numbers can specify data types, multiple formats of comments and strings are supported, key names do not need to be enclosed in double quotes, trailing commas can be omitted, and so on. These features can help users accurately express the data they need, and are also facilitate the modification and maintenance of _ASON_ documents.

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=4 orderedList=false} -->

<!-- code_chunk_output -->

- [ASON Document Example](#ason-document-example)
- [Comparison with JSON](#comparison-with-json)
- [File Extension](#file-extension)
- [Shared Library and API](#shared-library-and-api)
  - [Rust ASON Shared Library](#rust-ason-shared-library)
- [Specification](#specification)
  - [Numbers](#numbers)
    - [Integers](#integers)
    - [Decimal Floating-Point Numbers](#decimal-floating-point-numbers)
    - [Hexadecimal Floating-Point Numbers](#hexadecimal-floating-point-numbers)
    - [Data Types of Numbers](#data-types-of-numbers)
    - [Metric Prefixes](#metric-prefixes)
  - [Boolean](#boolean)
  - [Characters](#characters)
    - [Unicode Escape Characters](#unicode-escape-characters)
  - [Strings](#strings)
    - [Long Strings](#long-strings)
    - [Multiline Strings](#multiline-strings)
    - [Raw Strings](#raw-strings)
    - [Trimmed Strings](#trimmed-strings)
  - [Dates](#dates)
  - [Byte Data](#byte-data)
  - [Arrays](#arrays)
    - [Trailing Commas](#trailing-commas)
    - [Array Types](#array-types)
  - [Tuples](#tuples)
  - [Objects](#objects)
    - [Nesting](#nesting)
  - [Variants](#variants)
    - [Using Variants to Replace `null`](#using-variants-to-replace-null)
    - [Default Value of Object Fields](#default-value-of-object-fields)
  - [Comments](#comments)
    - [Line Comments](#line-comments)
    - [Block Comments](#block-comments)
    - [Documentation Comments](#documentation-comments)
    - [Mixed Comments](#mixed-comments)

<!-- /code_chunk_output -->

## ASON Document Example

A typical _ASON_ document contains only one _ASON_ object. The following is a example of an _ASON_ document:

```json
{
    string: "hello world"
    raw_string: r"[a-z]+"
    number: 123
    number_with_data_type: 123_456_789@long
    float: 3.14
    double: 6.626e-34@double
    bool: true
    date: d"2023-03-24 12:30:00+08:00"
    variant_with_value: Option::Some(123)
    variant_without_value: Option::None
    array: [1,2,3,]
    tuple: (1, "foo", true)
    object: {
        id: 123
        name: "leaf"
    }
}
```

It is worth mentioning that an _ASON_ document does not necessarily have to be an _ASON_ object, it can also be other _ASON_ values, such as an array, a tuple, or even a single number or string, all of which are valid _ASON_ values.

## Comparison with JSON

The _ASON_ format is very similar to the _JSON_ format, but there are a few significant differences:

- Numbers can have explicit data types.
- Floating-point numbers do not support values such as `Inf`, `-Inf`, `-0` and `NaN`.
- Hexadecimal and binary numbers are supported.
- The `null` value is not allowed, and is replaced by a new type called `Variant`.
- Object keys do not support double quotes.
- Strings do not support single quotes.
- Arrays require all of their elements to be of the same data type.
- Multiple formats of strings and comments are supported.
- `Date`, `Tuple`, and `Variant` data types are added.
- Trailing commas can be omitted.
- A comma can be added to the end of the last element of an array, tuple, or object.

## File Extension

The file extension for _ASON_ document is `*.ason`. Filename example:

`sample.ason`, `package.ason`

## Library and API

Currently, only the Rust implementation of _ASON_ serialization and deserialization library is provided.

### Rust ASON Library

Run the command `cargo add ason` in your project directory to add the _ASON_ library to your project.

This library provides two functions:

- `fn parse(s: &str) -> Result<AsonNode, ParseError>` for deserialization;
- `fn write(n: &AsonNode) -> String` for serialization.

**Deserialization**

Suppose you have the following _ASON_ text, which may come from a file or from the internet:

```json
{
    id: 123
    name: "foo"
}
```

The following code shows how to parse this text into an _ASON_ object and check the value of each member:

```rust
let text = "..."; // the ASON text above

let node = parse(text).unwrap();

if let AsonNode::Object(obj) = node {
    assert_eq!(
        &obj[0],
        &NameValuePair {
            name: "id".to_string(),
            value: Box::new(AsonNode::Number(NumberLiteral::Int(123)))
        }
    );

    assert_eq!(
        &obj[1],
        &NameValuePair {
            name: "name".to_string(),
            value: Box::new(AsonNode::String_("foo".to_string()))
        }
    );
}
```

**Serialization**

Suppose there is an object with two fields, their names and values are:

- name: "foo"
- version: "0.1.0"

The following code demonstrates how to convert this object into _ASON_ text:

```rust
let node = AsonNode::Object(vec![
    NameValuePair {
        name: "name".to_string(),
        value: Box::new(AsonNode::String_("foo".to_string())),
    },
    NameValuePair {
        name: "version".to_string(),
        value: Box::new(AsonNode::String_("0.1.0".to_string())),
    },
]);

let text = write(&node);
println!("{}", text);
```

The output text should be:

```json
{
    name: "foo"
    version: "0.1.0"
    dependencies: [
        {
            name: "random"
            version: Option::None
        }
        {
            name: "regex"
            version: Option::Some("1.0.1")
        }
    ]
}
```

## Utilities

The Rust ASON library also provides a utility "ason" which can be used to read and validate, or format an ASON document.

First install the utility with the following command:

`$ cargo install ason`

This command will add the executable `ason` to the `~/.cargo/bin` directory.

This usage of utility is:

```bash
$ ason <file_name>
```

For example:

`$ ason test.ason`

If the document "test.ason" has no errors, the program prints the formatted document to the terminal. The output can be redirected to a new file, e.g.:

`$ ason test.ason > new.ason`

## Specification

An _ASON_ document can only have one _ASON_ value.

An _ASON_ value can be either simple data, such as a number, a date, or a string. It can also be complex data composed of multiple simple _ASON_ values, such as an `Object`, an `Array`, a `Tuple`, or a `Variant`.

### Numbers

_ASON_ supports two types of numbers: integers and floating-point numbers.

Each _ASON_ number has a specific data type. By default, a number is first inferred to be an integer, and its data type is `int` (i.e. `i32`). If the number contains a decimal point or the letter "e" representing a power of 10, then the number will be inferred to be a floating-point number, and its data type is `float` (i.e. `f32`).

> _ASON_ floating-point numbers do not support `-0.0`, `+Inf`, `-Inf`, and `NaN`.

All numbers can be preceded by a minus sign "-" to represent a negative number, but a plus sign "+" is not allowed (because the default is positive). One or more underscore "_" characters can be added between any two digits to represent grouping, and the _ASON_ parser will automatically ignore the underscore characters between digits.

#### Integers

Integers can be represented in three formats: decimal, hexadecimal, and binary. The following are all valid integers:

- Decimal: `211`, `223_211`, `-2027`
- Hexadecimal: `0x1113`, `0x1719_abcd`, `-0xaabb`
- Binary: `0b1100`, `0b1010_0001`, `-0b1100`

> _ASON_ does not support octal integers, for example `0o755` is an invalid number, and `0644` is equivalent to `644`.

#### Decimal Floating-Point Numbers

When a number contains a period ".", the number will be inferred to be a floating-point number. In addition, _ASON_ numbers also support scientific notation, that is: using the letter "e" and a positive or negative integer to represent a power of 10. Obviously, when a number contains the letter "e", it will also be inferred to be a floating-point number.

Here are some examples of decimal floating-point numbers:

`3.14`, `-2.718`, `0.123`, `123.0`, `2.998e8`, `6.626e-34`, `-1.7588e+11`

Note that a floating-point number cannot start with a period "." or the letter "e", nor can it end with a period "." or the letter "e". The following are invalid numbers:

`.123`, `123.`, `e123`, `123e`

#### Hexadecimal Floating-Point Numbers

Inside a computer, decimal floating-point numbers sometimes lose precision due to rounding (i.e., the number you write will be approximated). When you need to represent a floating-point number accurately, you can use hexadecimal.

The format of a hexadecimal floating-point number is `0xh.hhhp±d`, which is the same as the format of a [hexadecimal floating-point consant/literal](https://en.cppreference.com/w/c/language/floating_constant) in C/C++. For example, `0x1.23p4` represents `(1x16^0 + 2x16^-1 + 3x16^-2) x 2^4 = (1.13671875 x 16)`, and its value is `18.1875`.

Here are some examples of hexadecimal floating-point numbers:

`0x1.921fb6p1`, `0x1.5bf0a8b145769p+1`, `0x1.23p-4`, `-0x1.23p4`

Note that the letter "p" and its following positive or negative integer cannot be omitted. For example, `0x3.14` and `0x3.14p` are both invalid numbers.

> _ASON_ does not support binary floating-point numbers. For example, `0b11.10` is an invalid number.

#### Data Types of Numbers

_ASON_ supports the following data types for numbers:

- 8-bit integer: `byte`, `ubyte`, `i8`, `u8`.
- 16-bit integer: `short`, `ushort`, `i16`, `u16`.
- 32-bit integer: `int`, `uint`, `i32`, `u32`.
- 64-bit integer: `long`, `ulong`, `i64`, `u64`.
- 32-bit floating-point number (i.e., single-precision): `float`, `f32`.
- 64-bit floating-point number (i.e., double-precision): `double`, `f64`.

Note that there are two styles for the data type names: one is the C language style, such as `short`, `int`, and `float`; the other is the Rust language style, such as `i16`, `i32`, and `f32`. Although the names are different, they are equivalent.

You can explicitly specify the data type of a number by adding the "@" symbol and the data type name to the end of the number. For example, `11@long` represents the `long` type number `11`, and `3.14@double` represents the `double` type numbers `3.14`.

If a number does not explicitly specify its data type, then for integers, its default data type is `int` (i.e., `i32`), and for floating-point numbers it is `float` (i.e., `f32`).

#### Metric Prefixes

_ASON_ supports adding a [metric prefix](https://en.wikipedia.org/wiki/Metric_prefix) to the end of a number to represent a multiple or fraction of a unit.

##### Integer Prefixes

For integers, _ASON_ supports the following prefixes:

| Prefix | 10^n  |
|--------|-------|
| E      | 10^18 |
| P      | 10^15 |
| T      | 10^12 |
| G      | 10^9  |
| M      | 10^6  |
| K      | 10^3  |

Examples of numbers with prefixes:

`100K`, `20M`, `3G`

They are equivalent to `100_000`, `20_000_000`, and `3_000_000_000`.

When the above prefixes are added to the end of a number, its data types is inferred to be `int`. You can add the specific data type name (limited to `int`, `uint`, `long`, `ulong`) to the end of these prefixes to explicitly specify its data type, such as `100K@uint`, `20M@long`.

It should be noted that since the multiple of the prefixes "E", "P", and "T" exceed the range of the `int` type, when using these three prefixes, you must explicitly specify the `long` or `ulong` data type, otherwise an "out of range" error will be thrown. For example, the number `12T` is an invalid number, you need to write it as `12T@long` or `12T@ulong`.

##### Binary Prefixes

_ASON_ also supports the following binary prefixes:

| Prefix | 2^n  |
|--------|------|
| EB     | 2^60 |
| PB     | 2^50 |
| TB     | 2^40 |
| GB     | 2^30 |
| MB     | 2^20 |
| KB     | 2^10 |

The letter "B" can also be written as the lowercase letter "i", for example "KB" and "Ki" are the same, and "TB" and "Ti" are also the same.

Examples of numbers with binary prefixes:

`100KB`, `20MB`, `3GB`

Their values are equal to `100 x 1024`, `20 x 1024 x 1024`, and `3 x 1024 x 1024 x 1024`.

> Hexadecimal and binary integers cannot have prefixes added, for example `0x24K` and `0b1010M` are both invalid numbers.

##### Decimal Prefixes

For decimals, _ASON_ supports the following prefixes:

| Prefix | 10^n   |
|--------|--------|
| m      | 10^-3  |
| u      | 10^-6  |
| n      | 10^-9  |
| p      | 10^-12 |
| f      | 10^-15 |
| a      | 10^-18 |

Examples of numbers with decimal prefixes:

`100m`, `20u`, `3n`

They are equivalent to `100e-3`, `20e-6`, `3e-9`.

When the above prefixes are added to the end of a number, its data type will be inferred to be `float`. You can add the data type name (limited to `float` and `double`) to the end of these prefixes to explicitly specify its data type, such as  `100m@double`, `20n@double`.

> Hexadecimal floating-point numbers cannot have prefixes added, for example `0x2.9p8m` is an invalid number.

### Boolean

Boolean values can only be `true` or `false`.

### Characters

A character value consists of a pair of single quote and a character, such as `'a'`, `'文'`.

For some special characters, _ASON_ uses a backslash `\` and an character to represent them. _ASON_ supports the following escape characters:

- `'\t'`: Horizontal tabulation
- `'\r'`: Carriage return (CR)
- `'\n'`: New line character (also called line feed, or LF)
- `'\0'`: Null character
- `'\''`: Single quote
- `'\"'`: Double quote
- `'\\'`: Backslash itself

_ASON_ does not support the following escape characters:

- `'\v'`: Vertical tabulation
- `'\f'`: Page breaking control character

#### Unicode Escape Characters

Characters can also be represented in the format `'\u{...}'`, where "..." is the code point of the Unicode character. For example, the hyphen `'-'` can be written as `'\u{2d}'`, and the character `'文'` can be written as `'\u{6587}'`.

It is worth mentioning that JavaScript supports the format `\uFFFF` to represent Unicode characters and `\xFF` to represent ASCII characters. These two formats are not supported by _ASON_.

> Note that some emojis may be composed of multiple Unicode characters, although they appear to be a single character when displayed. For example, the emoji 🤦‍♂️ is actually composed of 4 characters U+1F926, U+200D, U+2642, U+FE0F. If this emoji is enclosed in single quotes, it will be an invalid character. You can [look up here](https://unicode.org/emoji/charts/full-emoji-list.html) for the code points corresponding to specific emojis.

### Strings

A string consists of a pair of double quotes and a series of characters, such as `"abc"`, `"文字"`, `"😊🍍"`.

Any valid character can be used to form a string, including the escaped characters, such as `"foo\nbar"`, `"\u{2d}\u{6587}\0"`.

The escaped character `\"` should be used when representing the double quote in a string.

#### Long Strings

_ASON_ supports writing long strings on multiple lines. Just add a backslash `\` and a newline character at the end of the line, for example:

```json
"Hello, \
    World!"
```

The string above is equivalent to `"Hello, World!"`. Note that the leading whitespace on each line is automatically trimmed.

#### Multiline Strings

If a string consists of multiple paragraphs (lines), you can simply write them down as they are, and the newlines in the string will be preserved, for example:

```json
"Hello,
    World! I am
    ASON."
```

The string above is equivalent to:

```json
"Hello,\n    World! I am\n    ASON."
```

Note that in this case, the leading whitespace before each line will not be trimmed, which means that all normal characters, newlines, and whitespace between the two double quotes will be preserved.

#### Raw Strings

Sometimes the backslash `\` is exactly the character we need, for example when writing regular expressions. If we write all the backslashes as `\\`, it will be not only confusing but also error-prone. _ASON_ supports "raw strings", the format is `r"..."`.

In raw strings, the backslash character no longer has the escape function, and all escape characters will be disabled. In other words, all characters in the string will be preserved as is (expect for the double quotes which will terminate the string). For example:

```json
r"^\d*(\.\d+)?$"
```

The string above is equivalent to `"^\\d*(\\.\\d+)?$"`. It can be seen that in some special cases, using raw strings is much clearer than ordinary strings.

In addition to the backslash character, what if the double quote `"` is also the character we need? In this case, you can use the variant of the raw string, the format is `r#"..."#`. In this kind of string, unless you encounter the ending mark `"#`, all characters will be preserved as is, including double quotes. For example:

```json
r#"<a href="https://hemashushu.github.io/" title="Home">Home Page</a>"#
```

The string above is equivalent to:

```json
"<a href=\"https://hemashushu.github.io/\" title=\"Home\">Home Page</a>"
```

#### Trimmed Strings

When we write long text of multiple paragraphs, due to the indentation of the code, the text may be introduced with a lot of leading spaces. In general, we can only ensure the correctness of the text content by manually deleting the leading spaces of each line, but this will destroy the overall indentation. In order to solve this problem, _ASON_ introduces the special format of "trimmed string".

This type of string starts with the mark `r|"` and then the body starts on a new line and ends with the mark `|"` on a new line.

The leading space characters of each line in the body will be automatically trimmed according to the number of leading space characters in the first line. For example, if the number of leading space characters in the first line is 8, then each line of the body will be trimmed by up to 8 leading space characters.

Here is an example of a trimmed string:

```json
{
    id: 123
    dependencies: [
        {
            name: "foo"
            description: r|"
                A sample module
                Features:
                    1. Simple
                    2. Efficient
                Authored by Bar and licensed under the LGPL.
                "|
        }
    ]
}

```

In the example above, the value of the field "description" is a trimmed string. Because the number of leading space characters in its first line is 16, each line of the body will be trimmed by up to 16 leading space characters, so its value is equivalent to:

```json
"A sample module
Features:
    1. Simple
    2. Efficient
Authored by Bar and licensed under the LGPL."
```

When using trimmed strings, note the following:

- The start tag `r|"` must be followed immediately by a newline character.
- The end tag `|"` must start on a new line.
- The newline character after the start tag and the newline character at the end of the body do not belong to the body, they are part of the start tag and end tag. Therefore, in the above example, there are no newline characters at the beginning and end of the body.

### Dates

_ASON_ supports the date type, which is formatted as: `d"YYYY-MM-DD HH:mm:ss"`. The format of the date is similar to a regular string, but note that there is a letter "d" before the first double quote.

Here are some examples of dates:

- `d"2023-03-24 10:15:00"`
- `d"2035-06-23 13:50:30"`

As with the [RFC 3339](https://datatracker.ietf.org/doc/html/rfc3339) standard, you can add the letter 't' or 'T' between the date and time, for example:

- `d"2023-03-24t10:15:00"`
- `d"2035-06-23T13:50:30"`

You can also add the [Corrdinated Universal Time (UTC)](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) time zone at the end, for example:

- `d"2023-03-24 10:15:00+08:00"`
- `d"2035-06-23 13:50:30-01:00"`

You can also use the letter 'z' or 'Z' to represent the `+00:00` time zone, for example:

- `d"2023-03-24 10:15:00z"`
- `d"2035-06-23 13:50:30Z"`

Note that the time portion cannot be omitted. If you do not need the time portion in some cases, you can use `00:00:00` to fill it in. For example, `d"2023-04-09T00:00:00"`.

### Byte Data

Byte data is a segment of binary data in memory or storage media. _ASON_ supports representing byte data in the format `h"..."`. Where "..." is a series of two-digit hexadecimal byte values, for example:

`h"0011aabb"`

It should be noted that each byte value must be two digits, and if it is less than two digits, it must be padded with the number 0.

The letters 'a' to 'f' are case-insensitive, so the above byte data can also be written as:

`h"0011AABB"`

To more clearly represent the value of each byte, any number of spaces, hyphens, colons, tabs, carriage returns, and line feeds can be inserted between the digits, i.e. `[ -:\t\r\n]`. Therefore, the above byte data can also be written as:

- `h"00 11 aa bb"`
- `h"00-11-aa-bb"`
- `h"00:11:aa:bb"`

When the data is very long, it can also be written on multiple lines, for example:

```json
h"48 65 6C 6C    6F 2C 20 57
  6F 72 6C 64    21 20 49 20
  61 6D 20 41    53 4F 4E 2E"
```

### Arrays

An array is a collection of _ASON_ values of the same type, for example:

- `[1,2,3]`
- `["foo", "bar"]`
- `[true, false, true]`

ASON arrays require all of their elements to be of the same data type, for example `[1, "foo", false]` is an invalid array.

Array elements can be written on the same line, separated by commas. They can also be written on separate lines, with one element per line, for example:

```json
[
    "foo"
    "bar"
    "baz"
]
```

#### Trailing Commas

Unlike JSON, in _ASON_ documents, when writing elements on separate lines, the trailing comma can be omitted. _ASON_ recommends omitting trailing commas actually. Of course, it is also valid to add a trailing comma, for example:

```json
[
    "foo",
    "bar",
    "baz",
]
```

Another difference from _JSON_ is that a trailing comma can be added to the last element of an _ASON_ array, for example, in the above example a comma is added after "baz". A trailing comma can even be added to the last element on the same line, for example `[1,2,3,]`.

> The trailing comma rule also applies to _Tuples_ and _Objects_, which will be discussed in the following sections.

#### Array Types

Array elements can be of simple or complex types, such as tuples, objects, and even arrayss, for example:

```json
[
    [11, 13, 15]
    [23, 29]
    [31, 37, 39, 41]
]
```

Note that the number of elements in an array is not part of the "type", in other words, an `int` array with 3 elements has the same type as an `int` array with 2 elements. In the above example, we can see that there are three sub-arrays with different numbers of elements, but since their element data types are all `int`, the types of these three sub-arrays are the same, so they can be grouped as a big array.

### Tuples

Similar to arrays, tuples are also collections of _ASON_ values, but tuples do not require the data types of their elements to be the same. For example:

`(1, "foo", true)`

In addition, tuples use a pair of parentheses `(...)` to enclose the elements, while arrays use a pair of square brackets `[...]`.

> In terms of function, _ASON_ tuples are similar to _JSON_ lists.

### Objects

An object is a collection of one or more "name-value" pairs. For example:

```json
{
    name: "regex"
    version: "1.10.4"
    size: 247
}
```

The name is composed of the characters `[0-9a-zA-Z_]`, `\u{a0}...\u{d7ff}`, and `\u{e000}...\u{10ffff}`, and the name does not need to be enclosed in double quotes. The value can be any _ASON_ value.

> "Name-value" pairs are sometimes also called "fields".

#### Nesting

The value of a "name-value" pair can be any _ASON_ value, including values such as arrays, tuples, and objects. Therefore, nesting of objects is very common, for example:

```json
{
    name: "ason"
    version: "0.1.7"
    dependencies: [
        {
            name: "chrono"
            version: "^0.4.35"
        }
        {
            name: "hexfloat2"
            version: "^0.1.3"
        }
    ]
    tags: ["parser", "serde"]
}
```

### Variants

A variant is a special data type that wraps different types of data, similar to the `enum` in the Rust language.

The format of a variant is `name::category(value)`, where:

- `name` is a string composed of characters `[0-9a-zA-Z_]`, it is the name of the variant. _ASON_ will consider it the same data type as long as the name of the variant is the same.
- `category` is also composed characters `[0-9a-zA-Z_]`, it represents the different categories under the variant.
- `(value)` is an arbitrary _ASON_ value enclosed in parentheses, which can be ommited.

Here are some examples of the variant `Shape`:

- `Shape::Circle(2)`
- `Shape::Square(4)`
- `Shape::Rectangle((6,8))`

Note that the `((6,8))` above is not a typo, because `(6,8)` is a tuple, and the outer parentheses are the inherent format of the `Variant`. It means the same as `Shape::Rectangle({width: 6, height: 8})`.

Not all members of a variant must have `(value)`, for example the following variant `Color`:

- `Color::Red`
- `Color::Blue`
- `Color::RGB((128,0,250))`

Of which `Red` and `Blue` have no extra values, because they themselves are a category of the variant `Color`.

#### Using Variants to Replace `null`

In programming, `null` is a convenient but annoying value, it can lead to potential errors and a lot of defensive judgment statements. _ASON_ does not support `null`, instead of which is the variant `Option`. For example, if you need to express an integer that may not exist, you can write it like this:

- `Option::None`
- `Option::Some(123)`

#### Default Value of Object Fields

When writing an _ASON_ document, if the value of a field of an object is the variant `Option::None`, the field can be omitted. For example:

```json
{
    name: "ason"
    version: Option::None
}
```

Can be written as:

```json
{
    name: "ason"
}
```

### Comments

ASON supports 3 formats of comments: line comments, block comments, and documentation comments.

Comments in _ASON_ documents are for human consumption only, and they are completely ignored by _ASON_ parsers.

#### Line Comments

Line comments start with the `//` marker and continue to the end of the line, for example:

```json
{
    // this is a line comment
    id: 123   // this is a line comment also
}
```

#### Block Comments

Block comments start with the `/*` marker and end with the `*/` marker, for example:

```json
{
    /* this is a block comment */
    id: 123

    /*
     this is a block comment also
     */
    name: /* block comment can be everywhere */ "ason"
}
```

Block comments support nesting, for example:

```json
{
    /*
     level one /* level two */ level one again
     */
    id: 123
}
```

In nested block comments, the start and end markers must appear in pairs.

#### Documentation Comments

Documentation comments are used to write long texts. A documentation comment starts with a `"""` marker on a line by itself and ends with a `"""` marker on a line by itself, for example:

```json
{
    """
    This is a document comment.
    It can be very long.
    You can even write Markdown formatted text here.
    Until there are three consecutive double quotes on a single line.
    """
    id: 123
}
```

> Note that although the start and end markers must be on a line by themselves, leading whitespace on the markers is allowed.

#### Mixed Comments

Line comments, block comments, and documentation comments can be mixed, but note that **other comment markers** within a comment will be treated as plain text and will not be parsed as another comment, for example:

```json
{
    // this is a line comment, /* this is still a line comment. */
    id: 123
}
```

```json
{
    /* this is a block comment, // this is still a block comment. */
    id: 123
}


```

```json
{
    """
    this is a document comment,
    // this is still a document comment.
    /* this is still a document comment. */
    """
    id: 123
}

```

In all 3 examples above, there is only one comment.
