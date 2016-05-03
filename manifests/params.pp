# Add something intelligent
class users::params(

  Optional[
    Hash[
      String,
      Struct[{
        password   => Optional[String[0, default]],
        ssh        => Optional[
          Struct[{
            key       => String[1, default],
            key_label => String[1, default],
            key_type  => String[7, 7],
          }]
        ],
      }]
      ]
  ] $accounts,

  $mandatory_dependencies = {
    libshadow => 'gem',
    libuser   => 'apt',
    sudo      => 'apt',
  }
){
}
