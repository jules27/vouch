# Create admin user
User.create(first_name: "Julie", last_name: "Mao", email: "julie@sandboxindustries.com",
            password: "password", password_confirmation: "password",
            admin: true)

# Create restaurant category
BusinessType.create(name: "restaurant")

# Populate cities
City.create(name: "San Francisco")
City.create(name: "Chicago")
