package com.kh.teampro.board.restaurant;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Service
public class FoodService {
	
	@Autowired
	private FoodDao foodDao;
	
	// 맛집 전체 조회
	public List<FoodVo> getFoodList() throws Exception{
		List<FoodVo> list = foodDao.getFoodList();
		return list;
	}
	
	// 해당 맛집 상세보기
	public List<FoodVo> getFoodInfo(int bno) throws Exception{
		List<FoodVo> list = foodDao.getFoodInfo(bno);
		return list;
	}
	
	// 맛집 추가
	public void insertFood(FoodVo foodVo) throws Exception{
		
		
		foodDao.insertFood(foodVo);
	}
	
	// api 데이터 불러오기
//	@RequestMapping(value = "/restaurant", method = RequestMethod.GET)
	public void getFoodApi() throws Exception{
		String api_url = "http://apis.data.go.kr/6260000/FoodService/getFoodKr";
		String serviceKey = "azTHMfp6YjDVbFlU+L/3hvNoIISlb8V6wdFOtkejKQjLmzRnVhYAz+KL74NrlAwL+mhfSJOUiAmhChWpsm3eIQ==";
		String pageNo = "1";
		String numOfRows = "10";
		
		StringBuilder urlBuilder = new StringBuilder(api_url); /*URL*/
        urlBuilder.append("?serviceKey=" + URLEncoder.encode(serviceKey, "UTF-8")); 
        urlBuilder.append("&pageNo=" + URLEncoder.encode(pageNo, "UTF-8")); 
        urlBuilder.append("&numOfRows=" + URLEncoder.encode(numOfRows, "UTF-8")); 
        urlBuilder.append("&resultType=" + URLEncoder.encode("json", "UTF-8"));
        String uString = urlBuilder.toString();
        System.out.println("uString:" + uString);
        URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection)url.openConnection();
		conn.setRequestMethod("GET");
//			conn.setRequestProperty("Content-type", "application/json");
		System.out.println("Response code: " + conn.getResponseCode()); // getResponseCode : 200
		BufferedReader rd;
        
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
		    rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
		    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
		    sb.append(line);
		}
		rd.close();
		conn.disconnect();
		System.out.println("sb:" + sb.toString()); // 출력 확인 o. 10번 시도중에 1번 불려오는 정도, 페이지에서 조회했을 때는 바로 불려와짐

		/*-------------------------------*/
		
		String sbString = sb.toString();
		JSONObject sbObj = new JSONObject(sbString);
		JSONObject objFoodKr = (JSONObject)sbObj.get("getFoodKr");
		JSONArray jsonArray = (JSONArray)objFoodKr.get("item");
		
		// sbString을 JSONArray로 변환
//			JSONArray jsonArray = new org.json.JSONArray(sbString);

		//jsonArray를 사용하여 각각의 JSON 객체에서 데이터 추출
		
		List<FoodVo> list = new ArrayList<FoodVo>();
		for (int i = 0; i < jsonArray.length(); i++) {
			org.json.JSONObject obj = jsonArray.getJSONObject(i);
//			System.out.println("obj:" + obj);
//			System.out.println("===============");
			
			String rname = obj.getString("MAIN_TITLE");
			String content = obj.getString("ITEMCNTNTS");
			String location = obj.getString("GUGUN_NM");
			String address = obj.getString("ADDR1");
			String rnumber = obj.getString("CNTCT_TEL");
			String rurl = obj.getString("HOMEPAGE_URL");
			String openhours = obj.getString("USAGE_DAY_WEEK_AND_TIME");
			String menu = obj.getString("RPRSNTV_MENU");
			int lat = obj.getInt("LAT");
			int rlong = obj.getInt("LNG");
			String image = obj.getString("MAIN_IMG_NORMAL");
			String thumbimage = obj.getString("MAIN_IMG_THUMB");
			
			FoodVo foodVo = new FoodVo();
			
			foodVo.setBno(i + 1);
			foodVo.setRname(rname);
			foodVo.setContent(content);
			foodVo.setLocation(location);
			foodVo.setAddress(address);
			foodVo.setRnumber(rnumber);
			foodVo.setUrl(rurl);
			foodVo.setOpenhours(openhours);
			foodVo.setMenu(menu);
			foodVo.setLat(lat);
			foodVo.setRlong(rlong);
			foodVo.setImage(image);
			foodVo.setThumbimage(thumbimage);
			list.add(foodVo);
			
			foodDao.insertFood(foodVo);
		}
//		System.out.println("list:" + list);
	}

}
