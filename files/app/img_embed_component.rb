# frozen_string_literal: true

# This file is a copy from the ArcLight project (embed_component.rb).
# It should be reviewed for consistency when upgrading.

module Arclight
  # Render digital object links for a document
  class ImgEmbedComponent < ViewComponent::Base
    def initialize(presenter:, document_counter: nil, **kwargs) # rubocop:disable Lint/UnusedMethodArgument
      super()

      @document = presenter.document
      @presenter = presenter
    end

    def render?
      resources.any?
    end

    def embeddable_resources
      @embeddable_resources ||= resources.first(1).select { |object| embeddable?(object) }
    end

    def imgable_resources
      embeddable_resources.select { |object| object.href =~ include_patterns }
    end

    def linkable_resources
      embeddable_resources - imgable_resources
    end

    def linked_resources
      resources - embeddable_resources
    end

    def resources
      @resources ||= @document.digital_objects || []
    end

    def depth
      @document.parents.length || 0
    end

    def embeddable?(object)
      exclude_patterns.none? do |pattern|
        object.href =~ pattern
      end
    end

    def exclude_patterns
      Arclight::Engine.config.oembed_resource_exclude_patterns
    end

    def include_patterns
      /\.(jpe?g|png|svg)(\?|#|$)/i
    end
  end
end
