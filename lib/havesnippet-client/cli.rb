require 'optparse'
require 'time'

module HaveSnippet::Client
  class Cli
    def self.run
      new.run
    end

    def initialize
      @opts = {}
    end

    def run
      usage = <<END
Usage: #{$0} [options] [file]

Options:
END

      opt_parser = OptionParser.new do |opts|
        opts.banner = usage

        opts.on('-s', '--server URL', 'URL to the HaveSnippet server') do |v|
          @opts[:url] = v
        end

        opts.on('-k', '--api-key KEY', 'API key used to authenticate the user') do |v|
          @opts[:api_key] = v
        end
        
        opts.on('-f', '--filename NAME', 'File name, including the extension') do |v|
          @opts[:file_name] = v
        end
        
        opts.on('-l', '--language LANG', 'Language used to highlight the syntax') do |v|
          @opts[:api_key] = v
        end
        
        opts.on('-t', '--title TITLE', 'Title for the snippet') do |v|
          @opts[:title] = v
        end
        
        opts.on('-a', '--access MODE', %w(public unlisted logged private), 'Accessibility') do |v|
          @opts[:accessibility] = translate_access(v)
        end

        opts.on('-e', '--expiration DATE', 'Date of expiration in ISO 8601') do |v|
          @opts[:expiration] = Time.iso8601(v).to_i
        end

        {
          hour:  60*60,
          day:   60*60*24,
          week:  60*60*24*7,
          month: 60*60*24*7*30,
          year:  60*60*24*7*30*12
        }.each do |k, v|
          opts.on("--#{k}", "Expiration in one #{k}") do
            @opts[:expiration] = Time.now.to_i + v
          end
        end
      end

      opt_parser.parse!

      @opts[:file_name] = File.basename(ARGV[0]) if ARGV[0] && !@opts[:file_name]
      @opts[:content] = (ARGV[0] ? File.open(ARGV[0]) : STDIN).read

      c = HaveSnippet::Client::Client.new(@opts[:url], @opts[:api_key])
      res = c.paste(@opts)

      if res.ok?
        puts res.url

      else
        warn "Error occured:"
        res.errors.each do |k, v|
          warn "\t#{k}: #{v.join('; ')}"
        end
      end
    end

    def translate_access(v)
      dict = %w(public unlisted logged private)
      i = dict.index(v)
      raise ArgumentError, "'#[v}' is not a valid access mode" unless i
      i
    end
  end
end
