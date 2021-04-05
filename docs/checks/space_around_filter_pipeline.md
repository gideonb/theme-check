# Ensure consistent spacing inside around Liquid filter pipeline (`SpaceAroundFilterPipeline`)

Warns against inconsistent spacing around liquid filter pipeline.

## Check Details

This check is aimed at eliminating ugly Liquid:

:-1: Examples of **incorrect** code for this check:

```liquid
<!-- Around pipeline -->
{{ url| asset_url | img_tag }}
{% assign my_upcase_string = "Hello world" |  upcase %}
```

:+1: Examples of **correct** code for this check:

```liquid
{{ url | asset_url | img_tag }}
{% assign my_upcase_string = "Hello world" | upcase %}
```

## Check Options

The default configuration for this check is the following:

```yaml
SpaceAroundFilterPipeline:
  enabled: true
```

## When Not To Use It

If you don't care about the look of your code.

## Version

This check has been introduced in Theme Check THEME_CHECK_VERSION.

## Resources

- [Liquid Style Guide][styleguide]
- [Rule Source][codesource]
- [Documentation Source][docsource]

[styleguide]: https://github.com/Shopify/liquid-style-guide
[codesource]: /lib/theme_check/checks/space_around_filter_pipeline.rb
[docsource]: /docs/checks/space_around_filter_pipeline.md
