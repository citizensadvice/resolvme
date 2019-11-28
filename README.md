# Resolvme

[![Travis Build Status](https://travis-ci.org/citizensadvice/resolvme.svg?branch=master)](https://travis-ci.org/citizensadvice/resolvme)

Resolvme is a collection of resolver that can be used:

- with the command line tool to render ERB based templates
- as a gem, to import and use specific resolvers in your application

## Example

```
This is a vault key: <%= vault('/secret/my-secret', 'my-field') %>
This is a stack output: <%= cf_stack_output('my-cloudformation-stack', 'MyOutputName') %>
This is a certificate arn: <%= acm_cert_arn('*.example.org') %>
```

Because ERB is used in the main object, you're free to use all the potential of
the ruby programming language, but make sure the input comes from trusted
sources (as the input is real code that runs in the ruby interpreter).

## Setup

Run `bundle install`

## Usage

By default template files are read from the standard input and rendered into
the standard output, so you can use I/O redirection in your shell to read/write
from/to files. You can also use a process substitution pattern to pass the
output as a file to another process.

Input and output files can be also provided as argument to the program.

### Examples

```bash
# work with files
$ resolvme template out

# work with files (with I/O redirection)
$ resolvme < template > out

# work with helm
$ helm install my-chart -f <(resolvme < override-template)

# pipe into kubectl
$ resolvme < template | kubectl apply -f -
```
