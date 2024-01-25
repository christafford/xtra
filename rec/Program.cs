var inProgress = new HashSet<string>();
while (true) {
    var text = File.ReadAllText("scan-list.txt").Split('\n');
    foreach (var url in text) {
        if (url.StartsWith("#") || url.Length < 1 || inProgress.Contains(url)) {
            continue;
        }
        Thread.Sleep(5000);
        inProgress.Add(url);
        _ = Task.Run(async () =>
        {
            var recorder = new Recorder(url);
            await recorder.Run();
            inProgress.Remove(url);
        });
    }
    Thread.Sleep(2000);
}