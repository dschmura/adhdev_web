module ActionDispatch
  # This middleware is responsible for logging exceptions and
  # showing a debugging page in case the request is local.
  class DebugExceptions

    def render_for_browser_request(request, wrapper)
      template = create_template(request, wrapper)
      file = "rescues/#{wrapper.rescue_template}"

      if request.xhr?
        html = template.render(template: file, layout: "rescues/layout")
        body = build_turbolinks_response_to_render(html)
        format = "text/javascript"
      else
        body = template.render(template: file, layout: "rescues/layout")
        format = "text/html"
      end
      render(wrapper.status_code, body, format)
    end

    def build_turbolinks_response_to_render(html)
      escaped_html = ActionController::Base.helpers.j(html)

      #if (session = WebConsole::Session.from(Thread.current))
        #headers["X-Web-Console-Session-Id"] = session.id
        #headers["X-Web-Console-Mount-Point"] = mount_point

        #template = WebConsole::Template.new(env, session)
        #escaped_html.gsub!(/<\/body>/, "#{template.render("index")}\\0")
      #end

      <<-JS
    (function(){
      document.open();
      document.write("#{escaped_html}");
      document.close();

      window.scroll(0, 0);
    })();
      JS
    end

  end
end

# Currently causes issues with the JS response, it assumes an HTML response
#module WebConsole
  #class Middleware

    #def acceptable_content_type?(headers)
      #[Mime[:html], Mime[:js]].include? Mime::Type.parse(headers["Content-Type"].to_s).first
    #end

  #end
#end
