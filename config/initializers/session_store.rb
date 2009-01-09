# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = CONF[:session]

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

#-------------------------------------------------------------------------------

# Must use the default cookie session store for SWFUpload to work.

# http://d.hatena.ne.jp/kent013/20080815/1218783569

# hacks for swfupload + cookie store to work
# see http://blog.airbladesoftware.com/2007/8/8/uploading-files-with-swfupload
#
# also need to put
# session :cookie_only => false, :only => :create
# into the controller where the files are being uploaded (change method as appropriate)
class CGI::Session
  alias original_initialize initialize

  # The following code is a work-around for the Flash 8 bug that prevents our multiple file uploader
  # from sending the _session_id.  Here, we hack the Session#initialize method and force the session_id
  # to load from the query string via the request uri. (Tested on  Lighttpd, Mongrel, Apache), Rails 2.1
  def initialize(cgiwrapper, option = {})
    #RAILS_DEFAULT_LOGGER.debug "#{__FILE__}:#{__LINE__} Session options #{option.inspect} *********************"
    unless option['cookie_only']
      #RAILS_DEFAULT_LOGGER.debug "#{__FILE__}:#{__LINE__} Initializing session object #{cgiwrapper.env_table['RAW_POST_DATA']} *********************"
      session_key = option['session_key'] || '_session_id'

      query_string = if (rpd = cgiwrapper.env_table['RAW_POST_DATA']) and rpd != ''
        rpd
      elsif (qs = cgiwrapper.env_table['QUERY_STRING']) and qs != ''
        qs
      elsif (ru = cgiwrapper.env_table['REQUEST_URI'][0..-1]).include?('?')
        ru[(ru.index('?') + 1)..-1]
      end
      if query_string and query_string.include?(session_key)
        option['session_data'] = CGI.unescape(query_string.scan(/#{session_key}=(.*?)(&.*?)*$/).flatten.first)
      end
    end
    original_initialize(cgiwrapper,option)
  end
end

class CGI::Session::CookieStore
  alias original_initialize initialize
  def initialize(session, options = {})
    @session_data = options['session_data']
    original_initialize(session, options)
  end

  def read_cookie
    @session_data || @session.cgi.cookies[@cookie_options['name']].first
  end
end
