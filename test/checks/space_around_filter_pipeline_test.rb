# frozen_string_literal: true
require 'test_helper'

module ThemeCheck
  class SpaceAroundFilterPipelineTest < Minitest::Test
    def test_no_offense_for_consistent_spaces
      offenses = analyze_theme(
        SpaceAroundFilterPipeline.new,
        "templates/index.liquid" => <<~END,
          {{ url | asset_url | img_tag }}
          {% assign my_upcase_string = "Hello world" | upcase %}
        END
      )

      assert_offenses('', offenses)
    end

    def test_reports_missing_space
      offenses = analyze_theme(
        SpaceAroundFilterPipeline.new,
        "templates/index.liquid" => <<~END,
          {{ url| asset_url | img_tag }}
          {% assign my_upcase_string = "Hello world" |upcase %}
        END
      )

      assert_offenses(<<~END, offenses)
        Space missing before '|' at templates/index.liquid:1
        Space missing after '|' at templates/index.liquid:2
      END
    end

    def test_reports_extra_spaces
      offenses = analyze_theme(
        SpaceAroundFilterPipeline.new,
        "templates/index.liquid" => <<~END,
          {{ url  | asset_url | img_tag }}
          {{ 'Hello world' |  upcase }}
        END
      )

      assert_offenses(<<~END, offenses)
        Too many spaces before '|' at templates/index.liquid:1
        Too many spaces after '|' at templates/index.liquid:2
      END
    end
  end
end
