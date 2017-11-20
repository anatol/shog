class Object
  def deep_clone
    # https://stackoverflow.com/questions/8206523/how-to-create-a-deep-copy-of-an-object-in-ruby
    Marshal.load(Marshal.dump(self))
  end
end
