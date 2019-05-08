require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params, :already_built_response

  # Setup the controller
  def initialize(req, res)
    @req = req 
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    self.already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise 'attempted double render!'
    else 
      res['location'] = url
      res.status = 302
      @already_built_response = true
    end 
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise 'attempted double render!'
    else 
      res['Content-Type'] = content_type
      res.write(content)
      @already_built_response = true
    end 
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    dir_path = File.dirname(__FILE__) # save current directory to a variable (__FILE__ is the current file)
    # get full path of views file 
    template_full_path = File.join(
      dir_path, "..", "views", self.class.name.underscore, "#{template_name}.html.erb"
    )
    # snag that code
    template = File.read(template_full_path)

    # pass to our render_content method and use binding to hang onto 
    # controller ivars etc other parts of scope
    render_content(
      ERB.new(template).result(binding), 'text/html'
    )
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

