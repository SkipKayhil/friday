# frozen_string_literal: true

module Friday
  class DbotRunner
    class Ruby
      def initialize(runner)
        @runner = runner
      end

      def version
        full_ruby_version.match(/\d+\.\d+\.\d+/)
      end

      private

      def full_ruby_version
        # TODO: see comment in DBotRunner#file, ideally #send is not needed here
        # but #lockfile is cached and #fetch_file_if_present is not
        lockfile_version = Bundler::LockfileParser.new(
          @runner.send(:fetcher).send(:lockfile).content
        ).ruby_version

        return lockfile_version if lockfile_version

        ruby_version = @runner.file(".ruby-version")

        return ruby_version if ruby_version

        ""
      end
    end
  end
end
