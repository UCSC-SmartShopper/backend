import ballerina/io;

float MAX_VALUE = 999999999999999;

public function dijkstra(float[][] allCoordinates, function(float[],float[]) returns float calculate_distance) returns float[] {
    // Define the graph as an adjacency matrix
    float[][] graph = [];

    // Define the graph as an adjacency matrix
    foreach float[] coordinates1 in allCoordinates {
        float[] row = [];
        foreach float[] coordinates2 in allCoordinates {
            row.push(calculate_distance(coordinates1, coordinates2));
        }
        graph.push(row);
    }

    // Source vertex
    int source_vertex = 0;

    // Call the Dijkstra's algorithm
    float[] distances = util_dijkstra(graph, source_vertex);

    // Print the shortest distances from the source_vertex
    io:println("Vertex\tDistance from Source");
    foreach int i in 0 ..< distances.length() {
        io:println(i.toBalString() + "\t" + distances[i].toString());
    }
    return distances;
}

function util_dijkstra(float[][] graph, int src) returns float[] {
    int vertexCount = graph.length();

    // Array to store the shortest distances from the source
    float[] dist = [];

    foreach int i in 0 ..< vertexCount {
        dist.push(MAX_VALUE);
    }
    dist[src] = 0; // Distance to source itself is 0

    // Visited vertices
    boolean[] visited = [];

    foreach int i in 0 ..< vertexCount {
        visited.push(false);
    }

    foreach int count in 0 ..< vertexCount - 1 {
        // Pick the minimum distance vertex that has not been processed yet
        int u = minDistance(dist, visited);
        visited[u] = true; // Mark as visited

        // Update the distance of adjacent vertices
        foreach int v in 0 ..< vertexCount {
            if (!visited[v] && graph[u][v] != 0.0 && dist[u] != MAX_VALUE &&
                dist[u] + graph[u][v] < dist[v]) {
                dist[v] = dist[u] + graph[u][v];
            }
        }
    }
    return dist;
}

function minDistance(float[] dist, boolean[] visited) returns int {
    float min = MAX_VALUE;
    int minIndex = -1;

    foreach int v in 0 ..< dist.length() {
        if (!visited[v] && dist[v] <= min) {
            min = dist[v];
            minIndex = v;
        }
    }
    return minIndex;
}
