let
    // Define the URL of the webpage to load data from
    Url = "https://en.wikipedia.org/wiki/Java_version_history",
    // Function to convert an ordinal date string to a date
    OrdinaryDate = (ordinaryDate as text) =>
        let
            Parts = Splitter.SplitTextByWhitespace(QuoteStyle.None)(ordinaryDate),
            OrdinaryDay = Parts{0},
            Day = Text.Start(OrdinaryDay, Text.Length(OrdinaryDay) - 2)
        in
            Date.FromText(Day & " " & Parts{1} & " " & Parts{2}),
    // Load the first table from the webpage
    Source = Web.Page(Web.Contents(Url)){0}[Data],
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    RemovedLegend = Table.RemoveLastN(Headers, 1),
    SelectColumns = Table.SelectColumns(RemovedLegend, {"Version", "Release date"}),
    ParseDate = Table.TransformColumns(SelectColumns, {{"Release date", OrdinaryDate, type date}})
in
    ParseDate
