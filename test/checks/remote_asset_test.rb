# frozen_string_literal: true
require "test_helper"

module ThemeCheck
  class RemoteAssetTest < Minitest::Test
    def test_no_offense_for_good_behaviour
      offenses = analyze_theme(
        RemoteAsset.new,
        "templates/index.liquid" => <<~END,
          <!-- scripts -->
          <script src="{{ 'theme.js' | asset_url }}" defer></script>

          <!-- styles -->
          {{ 'theme.css' | asset_url | stylesheet_tag }}
          <link href="{{ 'theme.css' | asset_url }}" rel="stylesheet">

          <!-- images -->
          <img alt="logo" src="{{ 'heart.png' | asset_url }}" width="100" height="100">
          <img alt="logo" src="{{ 'heart.png' | asset_url }}" width="100" height="100"/>
          <source src="{{ 'heart.png' | asset_url }}">

          <!-- Good kind of URLs -->
          <source src="foo.png">
          <source src="/app/src/foo.png">
          <source src="blob:...">
          <source src="data:image/png;base64,...">
          <source src="{{ image.src | img_url }}">
          <source src="{{ image | img_url }}">

          <!-- all kinds of html_filters (while using asset_url filters) -->
          {{ url | asset_url | img_tag }}
          {{ url | asset_img_url | script_tag }}
          {{ url | file_img_url | img_tag }}
          {{ url | file_url | script_tag }}
          {{ url | global_asset_url | script_tag }}
          {{ url | payment_type_img_url | img_tag }}
          {{ url | shopify_asset_url | img_tag }}

          <!-- weird edge cases from the wild -->
          <img alt="logo" src="" data-src="{{ url | asset_url | img_tag }}" width="100" height="100" />
        END
      )
      assert_offenses("", offenses)
    end

    def test_no_offense_for_stuff_we_dont_care_about
      offenses = analyze_theme(
        RemoteAsset.new,
        "templates/index.liquid" => <<~END,
          <link href="https://dont.care" rel="preconnect">
        END
      )
      assert_offenses("", offenses)
    end

    def test_flag_use_of_scripts_to_remote_domains
      offenses = analyze_theme(
        RemoteAsset.new,
        "templates/index.liquid" => <<~END,
          <script src="https://example.com/jquery.js" defer></script>
        END
      )
      assert_offenses(<<~END, offenses)
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:1
      END
    end

    def test_flag_use_of_remote_stylesheet
      offenses = analyze_theme(
        RemoteAsset.new,
        "templates/index.liquid" => <<~END,
          <link href="https://example.com/bootstrap.css" rel="stylesheet">
          <link href="{{ "https://example.com/bootstrap.css" | replace: 'bootstrap', 'tailwind' }}" rel="stylesheet">
          {{ "https://example.com/tailwind.css" | stylesheet_tag }}
        END
      )
      assert_offenses(<<~END, offenses)
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:1
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:2
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:3
      END
    end

    # Note: this highlights how we might have a false positive for assign that uses the asset_url.
    # This doesn't feel like a common practice though.
    def test_flag_use_of_html_filter_without_asset_url_filter
      offenses = analyze_theme(
        RemoteAsset.new,
        "templates/index.liquid" => <<~END,
          {{ url | img_tag }}
          {{ url | script_tag }}
          {{ url | stylesheet_tag }}
        END
      )
      assert_offenses(<<~END, offenses)
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:1
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:2
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:3
      END
    end

    def test_flag_use_of_image_drops_without_img_url_filter
      offenses = analyze_theme(
        RemoteAsset.new,
        "templates/index.liquid" => <<~END,
          {{ image | img_tag }}
          {{ image.src | img_tag }}
          <img src="{{ image }}">
          <img src="{{ image.src }}">
        END
      )
      assert_offenses(<<~END, offenses)
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:1
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:2
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:3
        Asset should be served by the Shopify CDN for better performance. at templates/index.liquid:4
      END
    end
  end
end
