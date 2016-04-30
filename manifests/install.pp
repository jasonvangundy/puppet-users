# Install the dependencies of lostinmalloc-users
class users::install {

  $mandatory_dependencies = empty($::users::mandatory_dependencies) ? {
    false => $::users::mandatory_dependencies,
    true  => {},
  }

  if !empty($mandatory_dependencies) {
    $mandatory_dependencies.each |$dependency,$provider| {
      if !defined(Package[$dependency]) {
        Package { $dependency:
          ensure   => installed,
          provider => $provider,
          tag      => 'dependency',
        }
      }
    }
  }

}
