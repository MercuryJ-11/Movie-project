# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
require 'faker'

puts 'Cleaning up database...'
Movie.destroy_all
puts 'Database cleaned'

10.times do
  Movie.create([{
    title: Faker::Movie.title,
    overview: Faker::Company.catch_phrase,
    poster_url: Faker::File.dir,
    rating: rand(0..10)
  }])
end

puts Movie.all
puts 'movies created!'
=end

require 'open-uri'
require 'json'

puts 'Cleaning up database...'
Movie.destroy_all
puts 'Database cleaned'

url = 'http://tmdb.lewagon.com/movie/top_rated'
10.times do |i|
  puts "importing films from page #{ i + 1 }"
  movies = JSON.parse(open("#{url}?page=#{i + 1}").read)['results']
  movies.each do |movie|
    puts "Creating #{movie['title']}"
    poster_base_url = "https://image.tmdb.org/t/p/original"
    Movie.create(
      title: movie['title'],
      overview: movie['overview'],
      poster_url: movie["#{poster_base_url}#{movie['backdrop_path']}"],
      rating: movie['vote_average']
    )
  end
end

puts "Movies created"
