package DiaposApp::Schema::Result::Event;
use base qw/DBIx::Class::Core/;
         __PACKAGE__->table('event');
         __PACKAGE__->add_columns(qw/ box_id event_id event_year event_month event_name event_nb /);
         __PACKAGE__->set_primary_key('event_id');
         __PACKAGE__->has_many('subs' => 'DiaposApp::Schema::Result::Sub');
         __PACKAGE__->belongs_to('box_id' => 'DiaposApp::Schema::Result::Box');

         1;