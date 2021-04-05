# frozen_string_literal: true
module ThemeCheck
  class SpaceAroundFilterPipeline < LiquidCheck
    include RegexHelpers
    severity :style
    categories :liquid
    doc docs_url(__FILE__)

    def initialize
      @ignore = false
    end

    def on_node(node)
      return unless node.markup
      return if node.tag?

      node.markup.scan(/([|])\S+/) do |_match|
        add_offense("Space missing after '|'", node: node, markup: Regexp.last_match(0))
      end
      node.markup.scan(/\S([|])+/) do |_match|
        add_offense("Space missing before '|'", node: node, markup: Regexp.last_match(0))
      end
      node.markup.scan(/([|])  +/) do |_match|
        add_offense("Too many spaces after '|'", node: node, markup: Regexp.last_match(0))
      end
      node.markup.scan(/  ([|])+/) do |_match|
        add_offense("Too many spaces before '|'", node: node, markup: Regexp.last_match(0))
      end
    end
  end
end
