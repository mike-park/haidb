module PublicSignupsHelper
  def render_instructions(name)
    render "#{@basedir}/instructions", :instructions => name
  end
end
