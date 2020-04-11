import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class MongoLab {
    MongoClient client = MongoClients.create();
    MongoDatabase database = client.getDatabase("BartoszSzar_wt1115_B");

    protected long zad_6_5a(){
        MongoCollection<Document> business = database.getCollection("business");
        Document query = new Document("stars", 5);
        return business.count(query);
    }

    protected void zad_6_5b(){
        MongoCollection<Document> business = database.getCollection("business");
        AggregateIterable<Document> result = business.aggregate(
                Arrays.asList(
                        Aggregates.match(Filters.eq("categories", "Restaurants")),
                        Aggregates.group("$city", Accumulators.sum("no_of_restaurants", 1)),
                        Aggregates.sort(Sorts.descending("no_of_restaurants"))
                )
        );
        for (Object tuple : result){
            System.out.println(tuple);
        }
    }

    protected void zad_6_5c(){
        MongoCollection<Document> business = database.getCollection("business");
        AggregateIterable<Document> result = business.aggregate(
                Arrays.asList(
                        Aggregates.match(Filters.and(
                                            Filters.eq("categories", "Hotels"),
                                            Filters.eq("attributes.Wi-Fi", "free"),
                                            Filters.gte("stars", 4.5))),
                        Aggregates.group("$state", Accumulators.sum("no_of_hotels", 1)),
                        Aggregates.sort(Sorts.descending("no_of_hotels"))
                )
        );
        for (Object tuple : result){
            System.out.println(tuple);
        }
    }

    protected String zad7(){
        MongoCollection<Document> reviews = database.getCollection(("review"));
        MongoCollection<Document> users = database.getCollection(("user"));
        Object bestRatedUser = reviews.aggregate(
                Arrays.asList(
                        Aggregates.match(Filters.gte("stars", 4.5)),
                        Aggregates.group("$user_id", Accumulators.sum("no_of_reviews", 1)),
                        Aggregates.sort(Sorts.descending("no_of_reviews"))
                )).first().get("_id");
        return users.find(Filters.eq("user_id", bestRatedUser.toString())).first().get("name").toString();
    }

    List<String> zad8(){
            MongoCollection<Document> reviews = database.getCollection(("review"));
            List<String> no_of_votes = new ArrayList<>();

            no_of_votes.add("funny: " + reviews.countDocuments(
                    Filters.gt("votes.funny", 0)
            ));
            no_of_votes.add("cool: " + reviews.countDocuments(
                    Filters.gt("votes.cool", 0)
            ));
            no_of_votes.add("useful: " + reviews.countDocuments(
                    Filters.gt("votes.useful", 0)
            ));

            return no_of_votes;
    }
}
