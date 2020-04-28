class AddNewEnumTypesToUsersAndPunches < ActiveRecord::Migration[6.0]

  def up
    execute <<-SQL
        ALTER TABLE `users` MODIFY COLUMN `status` enum('clocked_in',
                                                        'clocked_out',
                                                        'on_break',
                                                        'remote_in');
    SQL
    execute <<-SQL
        ALTER TABLE `punches` MODIFY COLUMN `punch_type` enum('start_work',
                                                              'end_work',
                                                              'start_break',
                                                              'end_break',
                                                              'notes',
                                                              'remote_start',
                                                              'remote_end');
    SQL
  end

  def down
    execute <<-SQL
        ALTER TABLE users MODIFY COLUMN `status` enum('clocked_in',
                                                      'clocked_out',
                                                      'on_break');
    SQL
    execute <<-SQL
        ALTER TABLE punches MODIFY COLUMN `punch_type` enum('start_work',
                                                            'end_work',
                                                            'start_break',
                                                            'end_break',
                                                            'notes');
    SQL
  end

end