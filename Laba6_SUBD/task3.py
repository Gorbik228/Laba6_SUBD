from sqlalchemy.orm import Session
from sqlalchemy import Column, Date, Integer, String, Time, create_engine, text
from sqlalchemy.orm import DeclarativeBase

database_url_1 = r"mssql+pyodbc://lol:123456789aA@15-2-441-1-PREP/Sector2?driver=ODBC+Driver+17+for+SQL+Server&Encrypt=yes&TrustServerCertificate=yes&PersistSecurityInfo=no&Pooling=no&MultipleActiveResultSets=no"


engine1 = create_engine(database_url_1)
engine2 = create_engine(database_url_1)
engine3 = create_engine(database_url_1)
engine4 = create_engine(database_url_1)
engine5 = create_engine(database_url_1)
engine6 = create_engine(database_url_1)
engine7 = create_engine(database_url_1)
engine8 = create_engine(database_url_1)
engine9 = create_engine(database_url_1)
engine10= create_engine(database_url_1)
engine11= create_engine(database_url_1)
engine12= create_engine(database_url_1)

engine_list = [engine1 ,engine2,engine3, engine4, engine5, engine6 ,engine7 ,engine8 ,engine9 ,engine10,engine11,engine12]


class Base(DeclarativeBase):
    pass

class Logs(Base):
    __tablename__ = "User_Logs"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, nullable=False)
    user_action = Column(String, nullable=False)
    action_date = Column(Date, nullable=False)
    action_time = Column(Time, nullable=False)
    action_result = Column(String, nullable=False)

Base.metadata.create_all(bind=engine1)
Base.metadata.create_all(bind=engine2)


def inputt(engine:str, input_data:Logs):
    with Session(autoflush=False, bind=engine) as db:
        db.add(input_data)
        db.commit()

def sendto_shard(input_data:Logs, memory):
    inputt(engine=engine_list[memory], input_data = input_data)
    print(f"bd {memory+1}")
    memory = (memory + 1) 
    return memory


def main():
    input_data = Logs(username = "asd", user_action = "DELETE", action_date = "2023-01-01", action_time = "00:00:00", action_result = "OK")
    memory = 0
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)


if __name__ == "__main__":
    main()