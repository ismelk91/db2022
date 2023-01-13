package se.iths;

public class SQLConstants {
    public static final String JDBC_URL = "jdbc:mysql://localhost/Chinook";
    public static final String JDBC_USER = "iths";
    public static final String JDBC_PASSWORD = "iths";
    public static final String SQL_SELECT_ALL_ARTIST = "SELECT ArtistId, Name FROM Artist";
    public static final String SQL_ArtistId = "ArtistId";
    public static final String SQL_Artist_Name = "name";
    public static final String SQL_ARTIST_BY_ALBUM = "SELECT ArtistId, Name, AlbumId, Title FROM Artist JOIN Album USING (ArtistId) where ArtistId = ? ORDER BY ArtistId";
    public static final String SQL_ALBUM_ID = "AlbumId";
    public static final String SQL_ALBUM_TITLE = "title";
}