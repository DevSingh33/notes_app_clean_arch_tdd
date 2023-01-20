class ApiRoutes {
  static const port = 9000;
  static const ip4address = '192.168.1.35';
  static const baseURL = 'http://$ip4address:$port/api/notes/';

  static const fetchAllNotes = baseURL;
  static String fetchSingleNote(int id) =>'$baseURL$id';
  static const addNote = baseURL;
  static String deleteNote(int id) => '$baseURL$id';
  static String updateNote(int id) => '$baseURL$id';
}
