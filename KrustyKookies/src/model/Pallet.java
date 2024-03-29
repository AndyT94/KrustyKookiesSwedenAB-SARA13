package model;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Pallet {
	public int pallet_id;
	public String location;
	public String production_date;
	public Boolean blocked;
	public String recipe_name;

	public Pallet(ResultSet rs) throws SQLException {
		this.pallet_id = rs.getInt("pallet_id");
		this.location = rs.getString("location");
		this.production_date = rs.getString("production_date");
		this.blocked = rs.getBoolean("blocked");
		this.recipe_name = rs.getString("recipe_name");
	}

}
