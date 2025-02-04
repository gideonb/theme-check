# Discourage the use of large template files (`TemplateLength`)

This check exists to discourage the use of large template files. Use snippets to componentize your theme.

## Check Details

This check is aimed at eliminating large template files.

:-1: Examples of **incorrect** code for this check:

- Files that have more lines than the threshold

:+1: Examples of **correct** code for this check:

- Files that have less lines than the threshold

## Check Options

The default configuration for this check is the following:

```yaml
TemplateLength:
  enabled: true
  max_length: 200
  exclude_schema: true
```

### `max_length`

The `max_length` (Default: `200`) option determines the maximum number of lines allowed inside a liquid file.

### `exclude_schema`

The `exclude_schema` (Default: `true`) option determines if the schema lines from a template should be excluded from the line count.

## When Not To Use It

If you don't care about template lengths, then it's safe to disable this rule.

## Version

This check has been introduced in Theme Check 0.1.0.

## Resources

- [Rule Source][codesource]
- [Documentation Source][docsource]

[codesource]: /lib/theme_check/checks/template_length.rb
[docsource]: /docs/checks/template_length.md
