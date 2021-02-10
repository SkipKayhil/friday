# frozen_string_literal: true

# Vite asset helpers
module ViteHelper
  def javascript_vite_tag
    return tag.script(src: "dist/#{manifest.dig('main.jsx', 'file')}", type: 'module') unless Rails.env.development?

    sources = %w[
      http://localhost:4000/@vite/client
      http://localhost:4000/main.jsx
    ]

    safe_join(sources.map { |src| tag.script src: src, type: 'module' })
  end

  def stylesheet_vite_tag
    return if Rails.env.development?

    safe_join(
      manifest.dig('main.jsx', 'css').map { |path| tag.link(href: "dist/#{path}", rel: 'stylesheet') }
    )
  end

  private

  def manifest
    manifest_path = Rails.root.join('public/dist/manifest.json')
    @manifest ||= JSON.parse(File.read(manifest_path))
  end
end
