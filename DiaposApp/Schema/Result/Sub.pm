package DiaposApp::Schema::Result::Sub;
use base qw/DBIx::Class::Core/;
         __PACKAGE__->table('sub');
         __PACKAGE__->add_columns(qw/ box_id event_id sub_range sub_deb sub_fin sub_name/);
         __PACKAGE__->set_primary_key('sub_name');
         __PACKAGE__->belongs_to('event_id' => 'DiaposApp::Schema::Result::Event');

         1;