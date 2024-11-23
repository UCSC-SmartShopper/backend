import backend.db;

import ballerina/cache;

function init() returns error? {
    check baseCacheManager.put("productCache", true, 60); // 60 seconds
}

// --------------------------------- Manager Cache ---------------------------------
// Manager Cache is used to store the validity of the Product Cache
// When a request is made, it retuens old data and then updates the Cache
cache:Cache baseCacheManager = new ({
    capacity: 100,
    evictionFactor: 0.2,
    defaultMaxAge: 60 * 2,  // 2 minutes
    cleanupInterval: 60 * 2 // 2 minutes
});

CacheManager cacheManager = new ();

public class CacheManager {

    public function isValid(string key) returns boolean {
        any|cache:Error result = baseCacheManager.get(key);
        if (result is cache:Error) {
            return false;
        }
        return true;
    }

}

// --------------------------------- Product Cache ---------------------------------
// Product Cache will be invalidated every 24 hours, even if no requests are made
cache:Cache productCache = new ({
    capacity: 10,
    evictionFactor: 0.2,
    defaultMaxAge: 60 * 60 * 6,  // 6 hours
    cleanupInterval: 60 * 60 * 6 // 6 hours
});

public class ProductCache {
    public function put(string key, db:ProductWithRelations[] data) {
        cache:Error? putResult = productCache.put(key, data);
        if (putResult is cache:Error) {
        }

    }

    public function get(string key, function () returns db:ProductWithRelations[]|error fetchData) returns db:ProductWithRelations[]|error {
        any|cache:Error getResult = productCache.get(key);

        if getResult is cache:Error {

            // If the cache is empty, fetch the data
            db:ProductWithRelations[]|error products = fetchData();
            if products is db:ProductWithRelations[] {

                // Store the data in the cache
                cache:Error? putResult = productCache.put(key, products);
                if (putResult is cache:Error) {
                }
            }
            return products;

        } else {

            db:ProductWithRelations[] products = <db:ProductWithRelations[]>getResult;

            if (!cacheManager.isValid("productCache")) {
                _ = start fetchData();
            }
            return products;
        }
    }

    public function invalidate(string key) returns error? {
        return productCache.invalidate(key);
    }

    public function clear() returns error? {
        return productCache.invalidateAll();
    }
}

// --------------------------------- File Cache ---------------------------------
public cache:Cache fileCache = new ({
    capacity: 100,
    evictionFactor: 0.2,
    defaultMaxAge: 60 * 60 * 24 // 24 hours
});

public class FileCache {

    public function put(string key, byte[] data) {
        cache:Error? putResult = fileCache.put(key, data);
        if (putResult is cache:Error) {
        }

    }

    public function get(string key, function (string) returns byte[]|error fetchData) returns byte[]|error {
        any|cache:Error getResult = fileCache.get(key);

        if getResult is cache:Error {

            // If the cache is empty, fetch the data
            byte[]|error data = fetchData(key);
            if data is byte[] {

                // Store the data in the cache
                cache:Error? putResult = fileCache.put(key, data);
                if (putResult is cache:Error) {
                }
            }
            return data;

        } else {
            byte[] data = <byte[]>getResult;
            return data;
        }
    }

    public function invalidate(string key) returns error? {
        return fileCache.invalidate(key);
    }

    public function clear() returns error? {
        return fileCache.invalidateAll();
    }
}
