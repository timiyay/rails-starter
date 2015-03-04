def source_paths
  root_path = File.expand_path(File.dirname(__FILE__))
  Array(super) + [root_path, File.join(root_path, 'rails_root')]
end

# replace default Gemfile with template
remove_file 'Gemfile'
copy_file 'rails_root/Gemfile', 'Gemfile'

# copy dotfiles and any other development config
copy_file 'rails_root/.editorconfig', '.editorconfig'

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
].each  { |file_args| create_file(*file_args) }

# Configure Javascript file structure
remove_file 'app/assets/javascripts/application.js'
copy_file 'rails_root/app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
create_file 'app/assets/javascripts/main.js.coffee', '# Add your top-level Javascript here. This would be the place to load modules.'
