# Tmdb::Genre.list['genres'].map do |g|
#   { id: g['id'], title: g['name'], total_pages: Tmdb::Genre.detail(g['id']).total_pages }
# end
#   =>
#   [{:id=>28, :title=>"Бойовик", :total_pages=>1868},
#    {:id=>12, :title=>"Пригоди", :total_pages=>1018},
#    {:id=>16, :title=>"Мультфільм", :total_pages=>2364},
#    {:id=>35, :title=>"Комедія", :total_pages=>6025},
#    {:id=>80, :title=>"Кримінал", :total_pages=>1488},
#    {:id=>99, :title=>"Документальний", :total_pages=>6762},
#    {:id=>18, :title=>"Драма", :total_pages=>9818},
#    {:id=>10751, :title=>"Сімейний", :total_pages=>1174},
#    {:id=>14, :title=>"Фентезі", :total_pages=>934},
#    {:id=>36, :title=>"Історичний", :total_pages=>735},
#    {:id=>27, :title=>"Жахи", :total_pages=>2105},
#    {:id=>10402, :title=>"Музика", :total_pages=>1768},
#    {:id=>9648, :title=>"Детектив", :total_pages=>842},
#    {:id=>10749, :title=>"Мелодрама", :total_pages=>2292},
#    {:id=>878, :title=>"Фантастика", :total_pages=>890},
#    {:id=>10770, :title=>"Телефільм", :total_pages=>1082},
#    {:id=>53, :title=>"Трилер", :total_pages=>2014},
#    {:id=>10752, :title=>"Військовий", :total_pages=>475},
#    {:id=>37, :title=>"Вестерн", :total_pages=>416}]


class RandomMovieService < ApplicationService
  attr_reader :genre_id

  RETRY_COUNT       = 15
  PAGES_RANGE       = (1..20).to_a.freeze
  BASE_IMAGE_URL    = 'https://image.tmdb.org/t/p/w500'.freeze
  DEFAULT_GENRE_IDS = [
    35, 80, 99, 18, 9648, 10_752
  ].freeze

  def initialize(*genre_ids)
    @genre_id = genre_ids.sample || DEFAULT_GENRE_IDS.sample
  end

  def call
    RETRY_COUNT.times do
      random_movie = detail(movies.sample['id'])
      return format_movie_data(random_movie) unless random_movie['overview'].blank?

      puts 'Invalid translation for movie. Retrying...'
      sleep rand(1..5)
    end

    raise 'Invalid translation for movie'
  end

  private

  def format_movie_data(movie)
    {
      title: movie['title'],
      description: movie['overview'],
      rating: movie['vote_average'],
      poster_url: BASE_IMAGE_URL + movie['poster_path'],
      release_date: movie['release_date'],
      runtime: movie['runtime'],
      genres: movie['genres']&.map { |genre| genre['name'] } || [genre.name]
    }
  end

  def genre
    @genre ||= Tmdb::Genre.detail(genre_id, page: PAGES_RANGE.sample)
  end

  def movies
    @movies ||= genre.results
  end

  def detail(movie_id)
    movie = Tmdb::Movie.detail(movie_id)

    return movie unless movie['belongs_to_collection']

    collection_id = movie['belongs_to_collection']['id']
    collection = Tmdb::Collection.detail(collection_id)
    collection['parts'].first
  end
end
