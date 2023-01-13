package se.iths;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;

import static se.iths.SQLConstants.*;


public class App {

    public static void main(String[] args) {
        App app = new App();

        try{
            app.load();
        } catch (SQLException e) {
            System.err.println(String.format("Något gick fel vid inläsning av databasen! (%s)", e.toString()));
        }

    }

    private void load() throws SQLException {
        Collection<Artist> artists = loadArtists();
        for (Artist artist : artists) {
            System.out.println(artist);
        }
    }

    private Collection<Artist> loadArtists() throws SQLException {
        Collection<Artist> artists = new ArrayList<>();
        Connection con = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
        ResultSet rs = con.createStatement().executeQuery(SQL_SELECT_ALL_ARTIST);
        while (rs.next()) {
            long id = rs.getLong(SQL_ArtistId);
            String name = rs.getString(SQL_Artist_Name);
            Artist artist = new Artist(id, name);
            artists.add(artist);

            Collection<Album> albums = loadAlbums(artist.getId());
            for (Album album : albums) {
                artist.add(album);
            }
        }
        rs.close();
        con.close();
        return artists;
    }

    private Collection<Album> loadAlbums(long artistId) throws SQLException {
        Collection<Album> albums = new ArrayList<>();
        Connection con = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

        PreparedStatement stmt = con.prepareStatement(SQL_ARTIST_BY_ALBUM);
        stmt.setLong(1, artistId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            long id = rs.getLong(SQL_ALBUM_ID);
            String title = rs.getString(SQL_ALBUM_TITLE);
            Album album = new Album(id, title);
            albums.add(album);
        }
        rs.close();
        con.close();
        return albums;
    }

}
