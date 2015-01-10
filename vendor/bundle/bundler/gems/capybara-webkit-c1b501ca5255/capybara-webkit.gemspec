# -*- encoding: utf-8 -*-
# stub: capybara-webkit 1.3.0 ruby lib
# stub: extconf.rb

Gem::Specification.new do |s|
  s.name = "capybara-webkit"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["thoughtbot", "Joe Ferris", "Matt Horan", "Matt Mongeau", "Mike Burns", "Jason Morrison"]
  s.date = "2014-09-12"
  s.email = "support@thoughtbot.com"
  s.extensions = ["extconf.rb"]
  s.files = [".gitignore", ".rspec", ".travis.yml", "Appraisals", "CONTRIBUTING.md", "GOALS", "Gemfile", "Gemfile.lock", "LICENSE", "NEWS.md", "README.md", "Rakefile", "Vagrantfile", "bin/Info.plist", "capybara-webkit.gemspec", "extconf.rb", "gemfiles/2.0.gemfile", "gemfiles/2.0.gemfile.lock", "gemfiles/2.1.gemfile", "gemfiles/2.1.gemfile.lock", "gemfiles/2.2.gemfile", "gemfiles/2.2.gemfile.lock", "gemfiles/2.3.gemfile", "gemfiles/2.3.gemfile.lock", "gemfiles/2.4.gemfile", "gemfiles/2.4.gemfile.lock", "lib/capybara-webkit.rb", "lib/capybara/webkit.rb", "lib/capybara/webkit/browser.rb", "lib/capybara/webkit/connection.rb", "lib/capybara/webkit/cookie_jar.rb", "lib/capybara/webkit/driver.rb", "lib/capybara/webkit/errors.rb", "lib/capybara/webkit/matchers.rb", "lib/capybara/webkit/node.rb", "lib/capybara/webkit/socket_debugger.rb", "lib/capybara/webkit/version.rb", "lib/capybara_webkit_builder.rb", "spec/browser_spec.rb", "spec/capybara_webkit_builder_spec.rb", "spec/connection_spec.rb", "spec/cookie_jar_spec.rb", "spec/driver_rendering_spec.rb", "spec/driver_resize_window_spec.rb", "spec/driver_spec.rb", "spec/errors_spec.rb", "spec/integration/session_spec.rb", "spec/selenium_compatibility_spec.rb", "spec/self_signed_ssl_cert.rb", "spec/spec_helper.rb", "spec/support/app_runner.rb", "spec/support/matchers/include_response.rb", "src/AcceptAlert.cpp", "src/AcceptAlert.h", "src/Authenticate.cpp", "src/Authenticate.h", "src/Body.h", "src/ClearCookies.cpp", "src/ClearCookies.h", "src/ClearPromptText.cpp", "src/ClearPromptText.h", "src/Command.cpp", "src/Command.h", "src/CommandFactory.cpp", "src/CommandFactory.h", "src/CommandParser.cpp", "src/CommandParser.h", "src/Connection.cpp", "src/Connection.h", "src/ConsoleMessages.cpp", "src/ConsoleMessages.h", "src/CurrentUrl.cpp", "src/CurrentUrl.h", "src/EnableLogging.cpp", "src/EnableLogging.h", "src/ErrorMessage.cpp", "src/ErrorMessage.h", "src/Evaluate.cpp", "src/Evaluate.h", "src/Execute.cpp", "src/Execute.h", "src/FindCss.cpp", "src/FindCss.h", "src/FindModal.cpp", "src/FindModal.h", "src/FindXpath.cpp", "src/FindXpath.h", "src/FrameFocus.cpp", "src/FrameFocus.h", "src/GetCookies.cpp", "src/GetCookies.h", "src/GetTimeout.cpp", "src/GetTimeout.h", "src/GetWindowHandle.cpp", "src/GetWindowHandle.h", "src/GetWindowHandles.cpp", "src/GetWindowHandles.h", "src/GoBack.cpp", "src/GoBack.h", "src/GoForward.cpp", "src/GoForward.h", "src/Header.cpp", "src/Header.h", "src/Headers.cpp", "src/Headers.h", "src/IgnoreDebugOutput.cpp", "src/IgnoreDebugOutput.h", "src/IgnoreSslErrors.cpp", "src/IgnoreSslErrors.h", "src/InvocationResult.cpp", "src/InvocationResult.h", "src/JavascriptAlertMessages.cpp", "src/JavascriptAlertMessages.h", "src/JavascriptCommand.cpp", "src/JavascriptCommand.h", "src/JavascriptConfirmMessages.cpp", "src/JavascriptConfirmMessages.h", "src/JavascriptInvocation.cpp", "src/JavascriptInvocation.h", "src/JavascriptPromptMessages.cpp", "src/JavascriptPromptMessages.h", "src/JsonSerializer.cpp", "src/JsonSerializer.h", "src/NetworkAccessManager.cpp", "src/NetworkAccessManager.h", "src/NetworkCookieJar.cpp", "src/NetworkCookieJar.h", "src/NetworkReplyProxy.cpp", "src/NetworkReplyProxy.h", "src/NoOpReply.cpp", "src/NoOpReply.h", "src/Node.cpp", "src/Node.h", "src/NullCommand.cpp", "src/NullCommand.h", "src/PageLoadingCommand.cpp", "src/PageLoadingCommand.h", "src/Render.cpp", "src/Render.h", "src/Reset.cpp", "src/Reset.h", "src/Response.cpp", "src/Response.h", "src/Server.cpp", "src/Server.h", "src/SetConfirmAction.cpp", "src/SetConfirmAction.h", "src/SetCookie.cpp", "src/SetCookie.h", "src/SetPromptAction.cpp", "src/SetPromptAction.h", "src/SetPromptText.cpp", "src/SetPromptText.h", "src/SetProxy.cpp", "src/SetProxy.h", "src/SetSkipImageLoading.cpp", "src/SetSkipImageLoading.h", "src/SetTimeout.cpp", "src/SetTimeout.h", "src/SetUrlBlacklist.cpp", "src/SetUrlBlacklist.h", "src/SocketCommand.cpp", "src/SocketCommand.h", "src/Status.cpp", "src/Status.h", "src/StdinNotifier.cpp", "src/StdinNotifier.h", "src/TimeoutCommand.cpp", "src/TimeoutCommand.h", "src/Title.cpp", "src/Title.h", "src/UnsupportedContentHandler.cpp", "src/UnsupportedContentHandler.h", "src/Version.cpp", "src/Version.h", "src/Visit.cpp", "src/Visit.h", "src/WebPage.cpp", "src/WebPage.h", "src/WebPageManager.cpp", "src/WebPageManager.h", "src/WindowClose.cpp", "src/WindowClose.h", "src/WindowCommand.cpp", "src/WindowCommand.h", "src/WindowFocus.cpp", "src/WindowFocus.h", "src/WindowMaximize.cpp", "src/WindowMaximize.h", "src/WindowOpen.cpp", "src/WindowOpen.h", "src/WindowResize.cpp", "src/WindowResize.h", "src/WindowSize.cpp", "src/WindowSize.h", "src/body.cpp", "src/capybara.js", "src/find_command.h", "src/main.cpp", "src/pointer.png", "src/stable.h", "src/webkit_server.pro", "src/webkit_server.qrc", "templates/Command.cpp", "templates/Command.h", "test/testignoredebugoutput.cpp", "test/testwebkitserver.pro", "vagrant_setup.sh", "webkit_server.pro"]
  s.homepage = "http://github.com/thoughtbot/capybara-webkit"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.0")
  s.rubygems_version = "2.4.5"
  s.summary = "Headless Webkit driver for Capybara"
  s.test_files = ["spec/browser_spec.rb", "spec/capybara_webkit_builder_spec.rb", "spec/connection_spec.rb", "spec/cookie_jar_spec.rb", "spec/driver_rendering_spec.rb", "spec/driver_resize_window_spec.rb", "spec/driver_spec.rb", "spec/errors_spec.rb", "spec/integration/session_spec.rb", "spec/selenium_compatibility_spec.rb", "spec/self_signed_ssl_cert.rb", "spec/spec_helper.rb", "spec/support/app_runner.rb", "spec/support/matchers/include_response.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capybara>, ["< 2.5.0", ">= 2.0.2"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14.0"])
      s.add_development_dependency(%q<sinatra>, [">= 0"])
      s.add_development_dependency(%q<mini_magick>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, ["~> 0.4.0"])
      s.add_development_dependency(%q<selenium-webdriver>, [">= 0"])
      s.add_development_dependency(%q<launchy>, [">= 0"])
    else
      s.add_dependency(%q<capybara>, ["< 2.5.0", ">= 2.0.2"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.14.0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<mini_magick>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<appraisal>, ["~> 0.4.0"])
      s.add_dependency(%q<selenium-webdriver>, [">= 0"])
      s.add_dependency(%q<launchy>, [">= 0"])
    end
  else
    s.add_dependency(%q<capybara>, ["< 2.5.0", ">= 2.0.2"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.14.0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<mini_magick>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<appraisal>, ["~> 0.4.0"])
    s.add_dependency(%q<selenium-webdriver>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
  end
end
