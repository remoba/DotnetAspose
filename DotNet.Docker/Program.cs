using GroupDocs.Conversion;
using GroupDocs.Conversion.FileTypes;
using GroupDocs.Conversion.Options.Convert;

var result = ConvertToPng(File.ReadAllBytes("sample.pdf"), 150, 180);

File.WriteAllBytes("output.png", result);

byte[] ConvertToPng(byte[] source, int width, int height)
{
    var options = new ImageConvertOptions
    {
        Format = ImageFileType.Png,
        Width = width,
        Height = height,
        PageNumber = 1,
        PagesCount = 1,
        Pages = new List<int> { 1 }
    };

    return Convert(source, options);
}

byte[] Convert(byte[] source, ConvertOptions options)
{
    using var sourceStream = new MemoryStream(source);
    using var outputStream = new MemoryStream();

    using var converter = new Converter(() => sourceStream);

    converter.Convert(
        document: (_, _) => new MemoryStream(),
        documentCompleted: (_, _, _, resultStream) => resultStream.CopyTo(outputStream),
        convertOptions: options);

    Console.WriteLine("PngConverter has finished png file generation");

    outputStream.Seek(0, SeekOrigin.Begin);
    return outputStream.ToArray();
}