module BBCodeizer  
  class << self

    #:nodoc:
    Tags = {
      :start_code            => [ /\[code.*?\]/i,                              '<pre>' ],
      :end_code              => [ /\[\/code.*?\]/i,                            '</pre>' ],
      :start_quote           => [ /\[quote(?:=".*?")?\]/i,                     nil ],
      :start_quote_with_cite => [ /\[quote.*?="(.*?)"\]/i,                     '<blockquote>' ],
      :start_quote_sans_cite => [ /\[quote.*?\]/i,                             '<blockquote>' ],
      :end_quote             => [ /\[\/quote.*?\]/i,                           '</blockquote>' ],
      :bold                  => [ /\[b.*?\](.+?)\[\/b.*?\]/i,                  '<strong>\1</strong>' ],
      :image                 => [ /\[img.*?\](.+?)\[\/img.*?\]/i,              '<img src="\1" />' ],
      :italic                => [ /\[i.*?\](.+?)\[\/i.*?\]/i,                  '<em>\1</em>' ],
      :url_with_title        => [ /\[url.*?=(.+?)\](.+?)\[\/url.*?\]/i,        '<a href="\1">\2</a>' ],
      :url_sans_title        => [ /\[url.*?\](.+?)\[\/url.*?\]/i,              '<a href="\1">\1</a>' ],
      :underline             => [ /\[u.*?\](.+?)\[\/u.*?\]/i,                  '<u>\1</u>' ],
      :email_with_name       => [ /\[email.*?=(.+?)\](.+?)\[\/email.*?\]/i,    '<a href="mailto:\1">\2</a>' ],
      :email_sans_name       => [ /\[email.*?\](.+?)\[\/email.*?\]/i,          '<a href="mailto:\1">\1</a>' ],
      :size                  => [ /\[size.*?=(\d{1,2})\](.+?)\[\/size.*?\]/i,  '<span style="font-size: \1px">\2</span>' ],
      :color                 => [ /\[color.*?=([^;]+?)\](.+?)\[\/color.*?\]/i, '<span style="color: \1">\2</span>' ],

      :newline               => [ /\n/,                                        '<br />' ],

      # :-D  :grin:  :)
      :smiley_1              => [ /:\-D/,                                      '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-laughing.gif" />'],
      :smiley_2              => [ /:grin:/,                                    '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-laughing.gif" />'],
      :smiley_3              => [ /:\)/,                                       '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-smile.gif" />'],

      #:-)  :smile:  :(
      :smiley_4              => [ /:\-\)/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-embarassed.gif" />'],
      :smiley_5              => [ /:smile:/,                                   '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-foot-in-mouth.gif" />'],
      :smiley_6              => [ /:\(/,                                       '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-money-mouth.gif" />'],

      # :-(  :o  :-o
      :smiley_7              => [ /:\-\(/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-undecided.gif" />'],
      :smiley_8              => [ / :o /,                                        '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-cool.gif" />'],
      :smiley_9              => [ /:\-o/,                                      '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-yell.gif" />'],

      # :eek:  8O  8-O
      :smiley_10             => [ /:eek:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-innocent.gif" />'],
      :smiley_11             => [ /8O/,                                        '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-cool.gif" />'],
      :smiley_12             => [ /8\-O/,                                      '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-kiss.gif" />'],

      # :shock:  :?  :-?:
      :smiley_13            => [ /:shock:/,                                    '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-kiss.gif" />'],
      :smiley_14            => [ / :\? /,                                        '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-surprised.gif" />'],
      :smiley_15            => [ /:\-\?:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-undecided.gif" />'],

      # :???:  8)  8-) 
      :smiley_16            => [ /:\?\?\?:/,                                   '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-tongue-out.gif" />'],
      :smiley_17            => [ /8\)/,                                        '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-cool.gif" />'],
      :smiley_18            => [ /8\-\)/,                                      '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-wink.gif" />'],

      # :cool:  :lol:  :x 
      :smiley_19            => [ /:cool:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-tongue-out.gif" />'],
      :smiley_20            => [ /:lol:/,                                      '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-money-mouth.gif" />'],
      :smiley_21            => [ /:x/,                                         '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-yell.gif" />'],

      # :-x  :mad:  :P 
      :smiley_22            => [ /:\-x/,                                       '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-undecided.gif" />'],
      :smiley_23            => [ /:mad:/,                                      '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-laughing.gif.gif" />'],
      :smiley_24            => [ /:P/,                                         '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-tongue-out.gif" />'],

      # :-P  :razz:  :oops:
      :smiley_25            => [ /:\-P/,                                       '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-cool.gif" />'],
      :smiley_26            => [ /:razz:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-wink.gif" />'],
      :smiley_27            => [ /:oops:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-innocent.gif" />'],

      # :cry:  :evil:  :twisted:
      :smiley_28            => [ /:cry:/,                                      '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-cry.gif" />'],
      :smiley_29            => [ /:evil:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-yell.gif" />'],
      :smiley_30            => [ /:twisted:/,                                  '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-laughing.gif" />'],

      # :roll:  :wink:  ;)
      :smiley_31            => [ /:roll:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-surprised.gif" />'],
      :smiley_32            => [ /:wink:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-sealed.gif" />'],
      :smiley_33            => [ /;\)/,                                        '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-wink.gif" />'],

      # ;-)  :!:  :idea:
      :smiley_34            => [ /;\-\)/,                                      '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-sealed.gif" />'],
      :smiley_35            => [ /:\!:/,                                       '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-tongue-out.gif" />'],
      :smiley_36            => [ /:idea:/,                                     '<img src="/javascripts/tiny_mce/plugins/emotions/img/smiley-sealed.gif" />']
    }

    # Tags in this list are invoked. To deactivate a particular tag, call BBCodeizer.deactivate.
    # These names correspond to either names above or methods in this module.
    TagList = [ :bold,
                :image, :italic,
                :url_with_title, :url_sans_title, :underline,
                :email_with_name, :email_sans_name,
                :size, :color,
                :code, :quote,
                :newline,
                :smiley_1, :smiley_2, :smiley_3, :smiley_4, :smiley_5, :smiley_6, :smiley_7, :smiley_8,
                :smiley_9, :smiley_10, :smiley_11, :smiley_12, :smiley_13, :smiley_14, :smiley_15, :smiley_16,
                :smiley_17, :smiley_18, :smiley_19, :smiley_20, :smiley_21, :smiley_22, :smiley_23, :smiley_24,
                :smiley_25, :smiley_26, :smiley_27, :smiley_28, :smiley_29, :smiley_30, :smiley_31, :smiley_32,
                :smiley_33, :smiley_34, :smiley_35, :smiley_36 ]

    # Parses all bbcode in +text+ and returns a new HTML-formatted string.
    def bbcodeize(text)
      text = text.dup
      TagList.each do |tag|
        if Tags.has_key?(tag)
          apply_tag(text, tag)
        else
          self.send(tag, text)
        end
      end
      text
    end

    # Configuration option to deactivate particular +tags+.
    def deactivate(*tags)
      tags.each { |t| TagList.delete(t) }
    end

    # Configuration option to change the replacement string used for a particular +tag+. The source
    # code should be referenced to determine what an appropriate replacement +string+ would be.
    def replace_using(tag, string)
      Tags[tag][1] = string
    end
    
  private

    def code(string)
      # code tags must match, else don't do any replacing.
      #if string.scan(Tags[:start_code].first).size == string.scan(Tags[:end_code].first).size
        apply_tags(string, :start_code, :end_code)
      #end
    end
  
    def quote(string)
      # quotes must match, else don't do any replacing
      #if string.scan(Tags[:start_quote].first).size == string.scan(Tags[:end_quote].first).size
        apply_tags(string, :start_quote_with_cite, :start_quote_sans_cite, :end_quote)
      #end
    end

    def apply_tags(string, *tags)
      tags.each do |tag|
        string.gsub!(*Tags[tag])
      end
    end
    alias_method :apply_tag, :apply_tags
  end
end