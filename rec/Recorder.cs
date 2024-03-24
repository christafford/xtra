using System.Text;
using System.Text.RegularExpressions;

public class Recorder {
    private string _url;
    private string _name;
    private string _outputFileDir = "/run/media/chris/2339c114-57d3-46c4-aafc-08017858489f/saves/";

    public Recorder(string url) {
        _url = url;
        _name = _url.Replace("https://chaturbate.com/", string.Empty).TrimEnd('/');
    }
    public async Task Run() {
        try {
            string outputfile;
            var count = 1;
            while (true) {
                outputfile = _outputFileDir + _name + "/" + _name + "-" + count.ToString("0000#") + ".mp4";
                if (!File.Exists(outputfile))
                    break;
                count++;
            }

            var directory = Path.GetDirectoryName(outputfile);
            if (!Directory.Exists(directory)) {
                Directory.CreateDirectory(directory);
            }

            using (var httpClient = new HttpClient()) {
                var page = await httpClient.GetStringAsync(_url);

                var regex = new Regex("https://.*?playlist\\.m3u8");
                var match = regex.Match(page);
                if (match.Success) {
                    var playlistUrl = match.Value.Replace("\\u002D", "-");
                    string chunkUrl = null;
                    var errorCount = 0;
                    while (errorCount < 3) {
                        try {
                            var playlist = await httpClient.GetStringAsync(playlistUrl);
                            var resolutions = playlist.Split('\n').Where(x => x.EndsWith(".m3u8")).ToArray();
                            chunkUrl = playlistUrl.Substring(0, playlistUrl.LastIndexOf("/") + 1) + resolutions[resolutions.Count() - 3];
                            break;
                        }
                        catch (Exception ex) {
                            Console.WriteLine(_url + ": " + ex.Message);
                            errorCount ++;
                            Thread.Sleep(1000);
                        }
                    }
                    if (chunkUrl == null) {
                        Console.WriteLine("Cannot start " + _url);
                        return;
                    }

                    Console.WriteLine("Output file: " + outputfile);
                    
                    var mediaFilesBytes = await httpClient.GetByteArrayAsync(chunkUrl);
                    var mediaFiles = Encoding.UTF8.GetString(mediaFilesBytes).Split('\n').Where(x => x.EndsWith(".ts")).ToArray();
                    var alreadyRead = new HashSet<string>();
                    while (mediaFiles.Any()) {
                        using (var fileStream = new FileStream(outputfile, FileMode.Append)) {
                            foreach (var mediaFile in mediaFiles) {
                                var mediafileUrl = playlistUrl.Substring(0, playlistUrl.LastIndexOf("/") + 1) + mediaFile;
                                if (alreadyRead.Contains(mediafileUrl))
                                    continue;
                                alreadyRead.Add(mediafileUrl);
                                using (var mediaStream = await httpClient.GetStreamAsync(mediafileUrl)) {
                                    await mediaStream.CopyToAsync(fileStream);
                                }
                            }
                        }
                        mediaFilesBytes = await httpClient.GetByteArrayAsync(chunkUrl);
                        mediaFiles = Encoding.UTF8.GetString(mediaFilesBytes).Split('\n').Where(x => x.EndsWith(".ts")).ToArray();
                    }

                    Console.WriteLine("Cleanly exited " + outputfile);
                }
            }
        }
        catch (Exception ex) {
            Console.WriteLine(_url + ": " + ex.Message);
            Console.WriteLine(ex.StackTrace);
        }
    }
}
