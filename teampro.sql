create table tbl_user (
        userid varchar2(15) primary key,
        upw varchar2(15) not null,
        unickname varchar2(30) not null unique,
        upoint number default 0,
        uimg varchar2(300),
        uemail varchar2(40) not null,
        signupfrom varchar2(20) default 'home',
        joindate timestamp default sysdate,
        verified char(1) default 'F' check (verified in('T', 'F'))
);

insert into tbl_user (userid, upw, unickname, uemail)
values ('testuser', '1111', 'tester', 'test@mail.com');

commit;

select * from tbl_user;

create table tbl_attach(
    image1 varchar2(150),
    image2 varchar2(150),
    image3 varchar2(150),
    image4 varchar2(150),
    image5 varchar2(150),
    bno number references tbl_userboard(bno)
);

drop table tbl_attach;

create table tbl_userboard(
    bno number primary key,
    title varchar2(200) not null,
    content varchar2(3300) not null,
    writer varchar2(50) not null references tbl_user(unickname),
    regdate timestamp default sysdate,
    viewcnt number default 0,
    replycnt number default 0,
    contenthtml varchar2(3800)
);

create sequence seq_board_bno;

commit;

insert into tbl_userboard (bno, title, content, writer)
values (seq_board_bno.nextval, 'test', 'content', 'tester');

select * from tbl_userboard;

create table tbl_userreply(
    rno number primary key,
    bno number references tbl_userboard(bno),
    replytext varchar2(1000) not null,
    replyer varchar2(50) references tbl_user(unickname),
    regdate timestamp default sysdate,
    updatedate timestamp,
    rgroup number not null,
    rseq number not null,
    rlevel number not null,
    delete_yn char(1) default 'N'
);

create sequence seq_userreply_rno;

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 1, 'reply test', 'tester', 0, 0, 0);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 1, 'reply test2', 'tester', 1, 0, 0);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, 'reply test', 'tester', 0, 0, 0);

select * from tbl_userreply;

select count(*) from tbl_userreply
where bno = 2;

commit;

create table tbl_likeuserboard(
    unickname varchar2(30) not null references tbl_user(unickname),
    bno number not null references tbl_userboard(bno)
);

select * from tbl_userreply;

drop sequence seq_userreply_rno;

commit;

select * from tbl_userreply
where bno = 2;

select * from tbl_userboard;
select * from tbl_user;

insert into tbl_likeuserboard
values ('tester', 1);

select * from tbl_likeuserboard;

delete from tbl_likeuserboard
where bno = 1
and unickname = 'tester';

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글1', 'tester', 1, 0, 0);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글2', 'tester', 2, 0, 0);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글1의 댓글', 'tester', 1, 1, 1);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글1의 댓글2', 'tester', 1, 2, 2);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel, parentrno)
values (seq_userreply_rno.nextval, 2, '댓글1의 댓글의 댓글', 'tester', 1, 3, 2, 24);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel, parentrno)
values (seq_userreply_rno.nextval, 2, '댓글1의 댓글의 댓글2', 'tester', 1, 2, 2, 26);
-- 무한 대댓 처리
-- rseq: 같은 bgroup 내 parentrno가 동일한 댓글의 rseq + 1
-- 또는 rseq = 원댓글 +1, rlevel = 원댓글 + 1을 하고 rgroup, rseq, regdate 순으로 조회
-- 기존 댓글의 rseq 처리: 지금 등록할 댓글의 rseq보다 큰 데이터는 현재 rseq에서 1씩 증가

-- 대댓 계층 한단계만 허용
-- rlevel을 원댓 0, 대댓 1만 입력 가능
-- 기존 댓글의 rseq 처리 필요 없음. 새로 추가할 댓글의 rseq는 rgroup내 가장 큰 rseq값+1

alter table tbl_userreply
add parentrno number references tbl_userreply(rno);

select * from tbl_userreply
where bno = 2
order by rgroup, rseq, regdate;

commit;

create table tbl_userreply as select * from tbl_userreplyinf where 1=2;

alter table tbl_userreply
drop column parentrno;

select * from tbl_userreply;

drop sequence seq_userreply_rno;

create sequence seq_userreply_rno;

create sequence seq_userreply_rgroup;

-- 기본 입력값 : rgroup = seq.currval / rseq = 0 / rlevel = 0
-- 대댓 : rgroup = 원댓의 rgroup / rseq = rgroup 내 가장 큰 rseq값 + 1 / rlevel = 1
insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글1', 'tester', 0, 0, 0);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글2', 'tester', seq_userreply_rno.currval, 1, 1);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글3', 'tester', seq_userreply_rno.currval, 2, 1);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글2의 댓글1', 'tester', 2, 3, 1);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글2의 댓글2', 'tester', 2, 2, 1);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글2의 댓글3', 'tester', 2, 3, 1);

insert into tbl_userreply(rno, bno, replytext, replyer, rgroup, rseq, rlevel)
values (seq_userreply_rno.nextval, 2, '댓글3의 댓글1', 'tester', 3, 1, 1);

-- rseq 최대값 구하기
select max(rseq) from tbl_userreply
where rgroup = 2
and bno = 2;

select * from tbl_userreply
order by rgroup, rseq;

select count(*) from tbl_userreply;

commit;

select rgroup from tbl_userreply
where bno = 2
and rno = 3;

-- user 추가
insert into tbl_user(userid, upw, unickname, uemail)
values ('user2', '1234', 'star', 'star@mail.com');

commit;

select * from tbl_user;

-- 댓글 컬럼 추가
alter table tbl_userreply
add parentrno number;

select replyer parentreplyer from tbl_userreply
where replyer = (select rno from tbl_userreply 
            where rno = 15);

select rgroup from tbl_userreply
where rgroup in (select rgroup from tbl_userreply
                where delete_yn = 'Y');
                
select rgroup, sum(count(rgroup)) over(partition by rgroup) from tbl_userreply
where rgroup in (select rgroup from tbl_userreply
                where delete_yn = 'Y')
                group by rgroup;
              
select rgroup, sum(count(rgroup)) over(partition by rgroup) hi from tbl_userreply
where rgroup in (select rgroup from tbl_userreply
                where delete_yn = 'Y')
                and hi = 1
                group by rgroup;
                
select * from tbl_userreply where (
                select hi from (select rgroup, sum(count(rgroup)) over(partition by rgroup) as hi from tbl_userreply
                where rgroup in (select rgroup from tbl_userreply
                where delete_yn = 'Y')
                group by rgroup)) = 1;

select rgroup, hi from (select rgroup, sum(count(rgroup)) over(partition by rgroup) as hi from tbl_userreply
                where rgroup in (select rgroup from tbl_userreply
                where delete_yn = 'Y')
                group by rgroup)
                where hi = 1;

select * from tbl_userreply
where not (select hi from (select rgroup, sum(count(rgroup)) over(partition by rgroup) as hi from tbl_userreply
                where rgroup in (select rgroup from tbl_userreply
                where delete_yn = 'Y')
                group by rgroup)) = 1;

commit;

select count (*) from tbl_userreply
where delete_yn = 'N';

select count (*) from tbl_userreply
where delete_yn = 'Y';


select * from tbl_userreply
where rgroup = 22
and delete_yn = 'N';

select * from tbl_userreply
where bno = 2
order by rgroup, rseq;

update tbl_userreply
set replytext = '댓글 수정',
    updatedate = sysdate
where rno = 15;    

select count(*) from tbl_userreply
where rgroup = 41
and delete_yn = 'N';

-- userboard table에 likecnt 추가

update tbl_userboard
set viewcnt = viewcnt + 1
where bno = 2;

commit;

-- 여기부터 다시

create table tbl_userreply(
    rno number primary key,
    bno number references tbl_userboard(bno),
    replytext varchar2(1000) not null,
    replyer varchar2(50) references tbl_user(unickname),
    regdate timestamp default sysdate,
    updatedate timestamp,
    rgroup number not null,
    rseq number not null,
    rlevel number not null,
    delete_yn char(1) default 'N',
    parentreplyer varchar2(50) references tbl_user(unickname)
);

create sequence seq_userreply_rno;

alter table tbl_userreply
add parentreplyer varchar2(50) references tbl_user(unickname);

commit;

select * from tbl_userreply;

-- user 추가
insert into tbl_user(userid, upw, unickname, uemail)
values ('user2', '1234', 'star', 'star@mail.com');

-- userboard에 컬럼 추가
alter table tbl_userboard
add userid varchar2(15) not null references tbl_user(userid);

-- 댓글테이블에 컬럼 추가
alter table tbl_userreply
add userid varchar2(15) not null references tbl_user(userid);


select * from tbl_userboard
		order by regdate desc;

select * from all_sequences
where sequence_owner = 'TEAMPRO';

select seq_board_bno.nextval
from dual;
