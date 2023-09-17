class RandomTrackService < ApplicationService
  attr_reader :playlist_id

  DEFAULT_PLAYLIST_IDS = [
    '37i9dQZF1E4DTZUur7HqeC', # The Weeknd Radio
    '37i9dQZF1E4vIIV392R6kP', # Arctic Monkeys Radio
    '37i9dQZF1DZ06evO3scD5m', # This is Skryabin
    '0AoMVCK3eT8WXCE5GdpqZz', # 5 hours of Existential Echoes
    '37i9dQZF1DX6wLDSDxUkBO', # This is Maneskin
  ].freeze

  def initialize(*playlist_ids)
    @playlist_id = playlist_ids.empty? ? DEFAULT_PLAYLIST_IDS.sample : playlist_ids.sample
  end

  def call
    tracks = playlist.tracks(limit: 100)
    random_track = tracks.sample

    {
      name: random_track.name,
      preview_url: random_track.preview_url,
      external_urls: random_track.external_urls,
      artists: random_track.artists.map(&:name),
      duration_ms: random_track.duration_ms,
      image: random_track.album.images.first['url'],
      release_date: random_track.album.release_date
    }
  end

  private

  def playlist
    @playlist ||= RSpotify::Playlist.find_by_id(playlist_id)
  end
end
