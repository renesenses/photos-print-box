package DiaposApp::Schema::Result::Box;
use base qw/DBIx::Class::Core/;
         __PACKAGE__->table('box');
         __PACKAGE__->add_columns(qw/ box_id box_name /);
         __PACKAGE__->set_primary_key('box_id');
         __PACKAGE__->has_many('events' => 'DiaposApp::Schema::Result::Event');

         1;