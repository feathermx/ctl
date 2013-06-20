module Sprockets
	module SassFunctions
		def asset_path(path, kind = nil)
			ActiveSupport::Deprecation.warn "asset_path with two arguments is deprecated. Use asset_path(#{path}) instead." if kind
			path = Sass::Script::String.new(sprockets_context.asset_path(path.value), :string)
			Sass::Script::String.new( (ENV['RAILS_RELATIVE_URL_ROOT'] || '') + path.value, :string)
		end
	end
end