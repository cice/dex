Dex
===

What is dex?
------------

### Have you ever seen this?:

    # some_class.rb:
    class SomeClass
      # ...
    end
    
    # some_class_decorator.rb:
    module SomeClassDecorator
      # ...
    end
    
    # config/initializers/decorators.rb:
    config.to_prepare do
      SomeClass.send :include, SomeClassDecorator
      ...
      ...
      ...
    end
    
### What's so bad about this?

It destroys Rails' lazy loading. Every Class with a decorator get's preloaded, on every request (in development mode). Not lazy-loaded, preloaded in this initializer, even if it's never being used. That's incredibly slow. And sucks.

### So what was dex now?

It's just a lightweight extension to `ActiveSupport::Dependencies` to support lazy-loaded decorators. You still have to register decorators in an
initializer, but it won't cause a preload, but register a callback to load and include the decorator as soon as it's base-class gets lazy-loaded:

    # some_class.rb:
    class SomeClass
      # ...
    end
    
    # some_class_decorator.rb:
    module SomeClassDecorator
      # ...
    end
    
    # config/initializers/dex.rb
    ActiveSupport::Dependencies.register_dex 'SomeClass', 'SomeClassDecorator'
    ...