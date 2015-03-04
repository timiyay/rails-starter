def source_paths
  root_path = File.expand_path(File.dirname(__FILE__))
  Array(super) + [root_path, File.join(root_path, 'rails_root')]
end

# replace default Gemfile with template
remove_file 'Gemfile'
copy_file 'rails_root/Gemfile', 'Gemfile'

# Customises app and environment config
application %(
    config.generators do |g|
      g.orm             :active_record
      g.template_engine :slim
      g.test_framework  :rspec, fixture: false
    end
)

# config/environments/development.rb
environment 'config.action_mailer.default_url_options = { host: \'http://localhost:3000\' }', env: 'development'
environment 'config.assets.raise_production_errors = true', env: 'development'

# config/environments/production.rb
environment 'config.lograge.enabled = true', env: 'production'

# config/environments/test.rb
environment 'Rails.application.routes.default_url_options[:host] = \'http://localhost:3000\'', env: 'test'

# copy dotfiles and any other development config
remove_file 'README.rdoc'
create_file 'README.md'
copy_file 'rails_root/.editorconfig', '.editorconfig'
copy_file 'rails_root/.rspec', '.rspec'
copy_file 'rails_root/.rubocop.yml', '.rubocop.yml'
copy_file 'rails_root/.ruby-version', '.ruby-version'

# Create directories for modular SMCSS-inspired stylesheets
remove_file 'app/assets/stylesheets/application.css'
remove_file 'app/assets/stylesheets/main.scss'
copy_file 'rails_root/app/assets/stylesheets/application.css', 'app/assets/stylesheets/application.css'
copy_file 'rails_root/app/assets/stylesheets/main.scss', 'app/assets/stylesheets/main.scss'
%w(core components functions pages).each { |path| empty_directory File.join('app/assets/stylesheets/', path) }

copy_file 'rails_root/app/assets/stylesheets/core/_reset.scss', 'app/assets/stylesheets/core/_reset.scss'

[
  ['app/assets/stylesheets/core/_grid.scss', '// Import and add your grids.'],
  ['app/assets/stylesheets/core/_elements.scss', '// Add base styling to your HTML elements, if needed.'],
  ['app/assets/stylesheets/core/_colors.scss', '// Add SASS variables for your colors.'],
  ['app/assets/stylesheets/core/_dimensions.scss', '// Add SASS variables for your element sizes, converting from pixels if necessary (i.e. rem(24);)'],
  ['app/assets/stylesheets/core/_typography.scss', '// Add SASS variables for your font families, sizes, and weights']
].each { |file_args| create_file(*file_args) }

# Configure Javascript file structure
remove_file 'app/assets/javascripts/application.js'
copy_file 'rails_root/app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
create_file 'app/assets/javascripts/main.js.coffee', '# Add your top-level Javascript here. This would be the place to load modules.'

# Configure testing stack
remove_dir 'test'
[
  'spec/controllers',
  'spec/factories',
  'spec/fixtures',
  'spec/models',
  'spec/support'
].each { |dir_path| empty_directory dir_path }

copy_file 'rails_root/spec/spec_helper.rb', 'spec/spec_helper.rb'
copy_file 'rails_root/spec/support/database_cleaner.rb', 'spec/support/database_cleaner.rb'
copy_file 'rails_root/features/support/driver.rb', 'features/support/driver.rb'
copy_file 'rails_root/features/support/webmock.rb', 'features/support/webmock.rb'

after_bundle do
  run 'bundle exec rails generate cucumber:install'
  run 'bundle exec guard init'
  remove_file '.gitignore'
  copy_file 'rails_root/.gitignore', '.gitignore'
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
