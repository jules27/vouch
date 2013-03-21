namespace :db do
  desc "Add fake friends to development database"
  task :populate => :environment do
    # Create some users
    user_a = FactoryGirl.create(:user)
    user_b = FactoryGirl.create(:user)
    user_c = FactoryGirl.create(:user)
    user_d = FactoryGirl.create(:user)

    # Make them my friends
    Friendship.create!(user_id: 1, friend_id: user_a.id)
    Friendship.create!(user_id: 1, friend_id: user_b.id)
    Friendship.create!(user_id: 1, friend_id: user_c.id)
    Friendship.create!(user_id: 1, friend_id: user_d.id)

    # Make some lists for each user for each city
    [user_a, user_b, user_c, user_d].each do |u|
      City.all.each do |city|
        vouch_list = FactoryGirl.create(:vouch_list,
                                  owner_id: u.id,
                                  title: "#{u.name}'s List in #{city.name}",
                                  city_id: city.id)
        wish_list  = FactoryGirl.create(:wish_list,
                                  user_id: u.id,
                                  city_id: city.id)
      end
    end
  end # task

end