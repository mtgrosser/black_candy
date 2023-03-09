# frozen_string_literal: true

class Playlists::SongsController < ApplicationController
  before_action :find_playlist
  before_action :find_song, only: [:create, :destroy]

  include Playable

  def show
    @pagy, @songs = pagy(@playlist.songs.includes(:artist))
  end

  def create
    @playlist.songs.push(@song)
    flash[:success] = t("success.add_to_playlist")
  rescue ActiveRecord::RecordNotUnique
    flash[:error] = t("error.already_in_playlist")
  ensure
    redirect_back_with_referer_params(fallback_location: {action: "show"})
  end

  def destroy
    if params[:clear_all]
      @playlist.songs.clear
    else
      @playlist.songs.destroy(@song)
      flash.now[:success] = t("success.delete_from_playlist")
    end

    # for refresh playlist content, when remove last song from playlist
    redirect_to action: "show" if @playlist.songs.empty?
  end

  def update
    from_position = Integer(params[:from_position])
    to_position = Integer(params[:to_position])

    playlists_song = @playlist.playlists_songs.find_by(position: from_position)
    playlists_song.update(position: to_position)
  end

  private

  def find_playlist
    @playlist = Current.user.playlists.find(params[:playlist_id])
  end

  def find_song
    @song = Song.find(params[:song_id]) unless params[:clear_all]
  end

  def find_all_song_ids
    @song_ids = @playlist.song_ids
  end
end
